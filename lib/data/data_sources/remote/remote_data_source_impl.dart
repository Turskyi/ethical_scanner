import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_mappers/product_data_mapper.dart';
import 'package:ethical_scanner/data/data_mappers/product_result_data_mapper.dart';
import 'package:ethical_scanner/res/values/constants.dart' as constants;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  const RemoteDataSourceImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode input) {
    final String code = input.code;

    return OpenFoodAPIClient.getProductV3(
      ProductQueryConfiguration(
        code,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: <ProductField>[ProductField.ALL],
        version: ProductQueryVersion.v3,
      ),
    ).then((ProductResultV3 result) {
      final Product? resultProduct = result.product;
      if (resultProduct != null && result.hasSuccessfulStatus) {
        final ProductInfo product = resultProduct.toProductInfo();
        if (product.brand.isNotEmpty || product.name.isNotEmpty) {
          return _restClient
              .getTerrorismSponsors()
              .then((List<TerrorismSponsor> terrorismSponsors) {
            final bool isCompanyTerrorismSponsor =
                terrorismSponsors.sponsoredBy(
              product,
            );

            final String origin = product.origin;
            return product.copyWith(
              isCompanyTerrorismSponsor: isCompanyTerrorismSponsor,
              origin:
                  (origin.isEmpty && code.isNotEmpty && code.startsWith('460'))
                      ? 'russian'
                      : origin,
            );
          }).onError((_, __) => product);
        } else {
          return product;
        }
      } else if (result.status == ProductResultV3.statusFailure) {
        if (_isBarcode(input.code)) {
          return ProductInfo(barcode: input.code);
        } else if (_isWebsite(input.code)) {
          return ProductInfo(website: input.code);
        } else if (_isAmazonAsin(input.code)) {
          return const ProductInfo(brand: 'Amazon');
        }
      }
      throw NotFoundException(
        input.language.isEnglish
            ? 'Product information not found for barcode: ${input.code}.'
            : 'Інформація про продукт не знайдена для штрих-коду: '
                '${input.code}',
      );
    });
  }

  @override
  Future<String> getCountryFromAiAsFuture(String barcode) {
    return OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo',
      seed: 6,
      temperature: 0.2,
      maxTokens: 500,
      stop: <String>['\n'],
      messages: <OpenAIChatCompletionChoiceMessageModel>[
        OpenAIChatCompletionChoiceMessageModel(
          content: <OpenAIChatCompletionChoiceMessageContentItemModel>[
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'The country encoded in the barcode $barcode is',
            ),
          ],
          role: OpenAIChatMessageRole.user,
        ),
      ],
    ).then((OpenAIChatCompletionModel completion) {
      final String? country = completion
          .choices.firstOrNull?.message.content?.firstOrNull?.text
          ?.trim();
      return country ?? '';
    }).onError((_, __) => '');
  }

  @override
  Future<void> addProduct(ProductInfo product) async {
    final String ingredientsText = product.ingredientList.join(',');
    final Product newProduct = Product(
      barcode: product.barcode,
      productName: product.name,
      genericName: product.name,
      brands: product.brand,
      brandsTags: <String>[product.brand],
      countries: product.countrySold,
      countriesTags: product.countryTags,
      quantity: product.quantity,
      ingredients: product.ingredientList
          .mapIndexed(
            (int rank, String ingredient) => Ingredient(
              rank: rank,
              text: ingredient,
              vegan: product.isVegan
                  ? IngredientSpecialPropertyStatus.POSITIVE
                  : IngredientSpecialPropertyStatus.IGNORE,
              vegetarian: product.isVegetarian
                  ? IngredientSpecialPropertyStatus.POSITIVE
                  : IngredientSpecialPropertyStatus.IGNORE,
            ),
          )
          .toList(),
      ingredientsText: ingredientsText,
      categories: product.countryTags.join(','),
      categoriesTags: product.categoryTags,
      packaging: product.packaging,
      packagingTags: <String>[product.packaging],
    );

    final User openFoodUser = OpenFoodAPIConfiguration.globalUser ??
        const User(
          userId: Env.openFoodUserId,
          password: Env.openFoodPassword,
          comment: constants.openFoodUserComment,
        );
    try {
      await _saveProductToOpenFoodFacts(
        newProduct: newProduct,
        openFoodUser: openFoodUser,
      );
    } catch (error) {
      if (error is BadRequestError) {
        await _saveProductToOpenFoodFacts(
          newProduct: newProduct,
          openFoodUser: const User(
            userId: Env.openFoodBackupUserId,
            password: Env.openFoodPassword,
            comment: constants.openFoodUserComment,
          ),
        );
      }
    }
  }

  Future<void> _saveProductToOpenFoodFacts({
    required Product newProduct,
    required User openFoodUser,
  }) async {
    final Status result = await OpenFoodAPIClient.saveProduct(
      openFoodUser,
      newProduct,
    );

    if (result.status == HttpStatus.badRequest) {
      String formattedProductDetails = 'Product details not available or too '
          'large to print directly.';
      try {
        // Attempt to serialize the product to JSON for better readability if
        // it's complex.
        formattedProductDetails = jsonEncode(newProduct.toJson());
      } catch (e) {
        formattedProductDetails = 'Could not serialize product to JSON: $e. '
            'Basic details: Barcode: ${newProduct.barcode}, '
            'Name: ${newProduct.productName}';
      }

      final String debugMessage = """
      ===============================================================
      ERROR: Failed to save product to OpenFoodFacts (BadRequest)
      ---------------------------------------------------------------
      User ID: ${openFoodUser.userId}
      ---------------------------------------------------------------
      Product Sent (summary or full JSON if possible):
      $formattedProductDetails 
      ---------------------------------------------------------------
      API Response Status Code: ${result.status}
      API Response Status Details: 
      ${result.statusVerbose ?? 'No verbose status'}
      API Response Error Message: 
      ${result.error ?? 'No specific error message from API.'}
      API Response Body:
      ${result.body ?? 'No response body.'}
      ===============================================================
      """;
      debugPrint(debugMessage);
      throw BadRequestError(
        result.body != null
            ? 'Failed to save product. Server response: ${result.body}'
            : 'Product could not be added.\n${result.error ?? ''}. '
                'Status: ${result.status}',
      );
    } else if (result.status != 1) {
      throw Exception(
        'product could not be added ${result.error ?? ''}',
      );
    }
  }

  @override
  Future<void> addIngredients(ProductPhoto photo) {
    final SendImage image = SendImage(
      barcode: photo.info.barcode,
      imageUri: Uri.parse(photo.path),
      imageField: ImageField.INGREDIENTS,
    );
    final User openFoodUser = OpenFoodAPIConfiguration.globalUser ??
        const User(
          userId: Env.openFoodUserId,
          password: Env.openFoodPassword,
          comment: constants.openFoodUserComment,
        );

    return _uploadProductImageToOpenFoodFacts(
      image: image,
      openFoodUser: openFoodUser,
    );
  }

  Future<void> _uploadProductImageToOpenFoodFacts({
    required SendImage image,
    required User openFoodUser,
  }) async {
    try {
      final Status status = await OpenFoodAPIClient.addProductImage(
        openFoodUser,
        image,
      );

      if (status.status == HttpStatus.internalServerError) {
        throw InternalServerError(
          'Image could not be uploaded: ${status.error}.\n'
          '${status.imageId != null ? status.imageId.toString() : ''}',
        );
      } else if (status.status == HttpStatus.forbidden &&
          openFoodUser.userId != Env.openFoodBackupUserId) {
        debugPrint(
          'WARN: Image upload forbidden for primary user '
          "'${openFoodUser.userId}' (barcode: ${image.barcode}). Attempting "
          "with backup user '${Env.openFoodBackupUserId}'.",
        );
        await _uploadProductImageToOpenFoodFacts(
          image: image,
          openFoodUser: const User(
            userId: Env.openFoodBackupUserId,
            password: Env.openFoodPassword,
            comment: constants.openFoodUserComment,
          ),
        );
      } else if (status.status == HttpStatus.forbidden) {
        // This means the upload was forbidden EVEN FOR THE BACKUP USER.
        // This is a critical failure for this operation. Log and throw a
        // specific error.
        final String errorMessage =
            'Image upload failed: Forbidden for both primary user and backup '
            "user ('${Env.openFoodBackupUserId}').";
        final String debugMessage = """
        ===============================================================
        CRITICAL ERROR: Image upload forbidden even for Backup User
        ---------------------------------------------------------------
        Attempted Backup User ID: ${openFoodUser.userId} (which is Env.openFoodBackupUserId)
        Barcode: ${image.barcode}
        Image URI: ${image.imageUri}
        Image Field: ${image.imageField}
        ---------------------------------------------------------------
        API Response Status Code: ${status.status}
        API Response Status Details: ${status.statusVerbose ?? 'No verbose status'}
        API Response Error Message: ${status.error ?? 'No specific error message from API.'}
        API Response Body: ${status.body ?? 'No response body.'}
        ===============================================================
        """;
        debugPrint(debugMessage);
        throw BackupUserForbiddenException(
          message: errorMessage,
          barcode: image.barcode,
          attemptedUserId: openFoodUser.userId,
        );
      } else if (status.status != 'status ok') {
        throw Exception(
          'image could not be uploaded: ${status.error}.\n'
          '${status.imageId != null ? status.imageId.toString() : ''}',
        );
      }
    } on ClientException catch (e, s) {
      // Specifically catch ClientException.

      final String caughtExceptionType = e.runtimeType.toString();
      String additionalContext = '';

      // Check for Connection Refused specifically.
      if (e.message.toLowerCase().contains('connection refused')) {
        additionalContext =
            '\nPOSSIBLE CAUSE: Network issue, server (world.openfoodfacts.org) down/misconfigured, or incorrect API '
            'endpoint/port being used by the HTTP client. Ensure the endpoint is correct and accessible (usually HTTPS port 443).';

        if (e.uri != null) {
          additionalContext += '\nAttempted URI: ${e.uri}';

          if ('${e.uri}' ==
              'https://world.openfoodfacts.org/cgi/product_image_upload.pl') {
            final String detailedMessage =
                'Could not connect to the Open Food Facts image upload server. '
                'Please check your internet connection or try again later. '
                '(Details: Connection refused to ${e.uri})';

            String debugLog = '''
          ===============================================================
          CRITICAL ERROR (ApiConnectionRefusedException Thrown)
          ---------------------------------------------------------------
          Exception Type: ApiConnectionRefusedException (wrapping $caughtExceptionType)
          Exception Message: $detailedMessage
          Original Exception: $e
          $additionalContext
          ---------------------------------------------------------------
          User ID: ${openFoodUser.userId}
          Barcode: ${image.barcode}
          Image URI: ${image.imageUri}
          Image Field: ${image.imageField}
          ---------------------------------------------------------------
          Stack Trace for original ClientException:
          $s
          ===============================================================
          ''';
            debugPrint(debugLog);

            // Throw custom, more specific exception.
            throw ApiConnectionRefusedException(
              message: detailedMessage,
              attemptedUri: e.uri,
              // Store the original raw message.
              originalExceptionMessage: e.message,
            );
          }
        }
      }
      // Fallback logging for other ClientExceptions or if the specific URI
      // condition wasn't met.
      String debugMessage = '''
    ===============================================================
    CLIENT EXCEPTION during _uploadProductImageToOpenFoodFacts
    ---------------------------------------------------------------
    Exception Type: $caughtExceptionType
    Exception Message: $e
    $additionalContext
    ---------------------------------------------------------------
    User ID: ${openFoodUser.userId}
    Barcode: ${image.barcode}
    Image URI: ${image.imageUri}
    Image Field: ${image.imageField}
    ---------------------------------------------------------------
    Stack Trace: $s
    ===============================================================
    ''';
      debugPrint(debugMessage);
      // Rethrow the original ClientException if not handled by custom
      // exception.
      rethrow;
    } catch (e, s) {
      // Catch ANY exception from OpenFoodAPIClient.addProductImage or
      // subsequent logic.

      final String caughtExceptionType = e.runtimeType.toString();
      String additionalContext = '';

      String debugMessage = '''
      ===============================================================
      CRITICAL ERROR during _uploadProductImageToOpenFoodFacts
      ---------------------------------------------------------------
      Exception Type: $caughtExceptionType
      Exception Message: $e
      $additionalContext
      ---------------------------------------------------------------
      User ID: ${openFoodUser.userId}
      Barcode: ${image.barcode}
      Image URI: ${image.imageUri}
      Image Field: ${image.imageField}
      ---------------------------------------------------------------
      Stack Trace: $s
      ===============================================================
      ''';

      debugPrint(debugMessage);
      // Rethrow the error to be handled by the calling method
      // (_onAddIngredientsPhoto).
      rethrow;
    }
  }

  /// Extract the ingredients of an existing product of the OpenFoodFacts
  /// database that has already ingredient image otherwise it should be added
  /// first to the server and then this can be called.
  @override
  Future<String> getIngredientsText(LocalizedCode barcode) =>
      OpenFoodAPIClient.extractIngredients(
        OpenFoodAPIConfiguration.globalUser ??
            const User(
              userId: Env.openFoodUserId,
              password: Env.openFoodPassword,
              comment: constants.openFoodUserComment,
            ),
        barcode.code,
        barcode.language.isEnglish
            ? OpenFoodFactsLanguage.ENGLISH
            : OpenFoodFactsLanguage.UKRAINIAN,
      ).then(
        (OcrIngredientsResult response) =>
            response.status != 0 ? '' : response.ingredientsTextFromImage ?? '',
      );

  bool _isWebsite(String input) {
    final RegExp regex = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]'
      r'{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
    );
    return regex.hasMatch(input);
  }

  /// Checks if the provided [barcode] is a valid Amazon ASIN.
  ///
  /// Amazon ASINs typically follow the pattern: A followed by 10 characters,
  /// which are typically alphanumeric.
  ///
  /// Returns `true` if [barcode] is a valid Amazon ASIN, and `false` otherwise.
  bool _isAmazonAsin(String barcode) {
    final RegExp asinPattern = RegExp(r'^[A-Z0-9]{10}$');
    return asinPattern.hasMatch(barcode);
  }

  bool _isBarcode(String input) {
    // Typical barcodes are between 8 and 14 digits long.
    if (input.length < 8 || input.length > 14) {
      return false;
    }
    // Check if the string contains only digits
    for (int i = 0; i < input.length; i++) {
      if (input.codeUnitAt(i) < '0'.codeUnitAt(0) ||
          input.codeUnitAt(i) > '9'.codeUnitAt(0)) {
        return false;
      }
    }
    return true;
  }

  /// Extract the ingredients of an existing product of the OpenFoodFacts
  /// database that does not have ingredient image and then save it back to the
  /// OFF server.
  // ignore: unused_element
  Future<void> _saveAndExtractIngredient(ProductPhoto photo) async {
    // A registered user login for https://world.openfoodfacts.org/ is required.
    final User user = OpenFoodAPIConfiguration.globalUser ??
        const User(
          userId: Env.openFoodUserId,
          password: Env.openFoodPassword,
          comment: constants.openFoodUserComment,
        );
    final OpenFoodFactsLanguage language = photo.info.language.isEnglish
        ? OpenFoodFactsLanguage.ENGLISH
        : OpenFoodFactsLanguage.UKRAINIAN;
    final SendImage image = SendImage(
      barcode: photo.info.barcode,
      imageUri: Uri.parse(photo.path),
      imageField: ImageField.INGREDIENTS,
    );

    //Add the ingredients image to the server
    Status results = await OpenFoodAPIClient.addProductImage(user, image);

    if (results.status == null) {
      throw Exception('Adding image failed');
    }

    final OcrIngredientsResult ocrResponse =
        await OpenFoodAPIClient.extractIngredients(
      user,
      photo.info.barcode,
      language,
    );

    if (ocrResponse.status != 0) {
      throw Exception("Text can't be extracted.");
    }

    final ProductInfo product = photo.info;
    final String ingredientsText = ocrResponse.ingredientsTextFromImage ??
        photo.info.ingredientList.join(',');
    final Product editedProduct = Product(
      barcode: product.barcode,
      productName: product.name,
      productNameInLanguages: <OpenFoodFactsLanguage, String>{
        language: product.name,
      },
      genericName: product.name,
      brands: product.brand,
      brandsTags: <String>[product.brand],
      countries: product.countrySold,
      countriesTags: product.countryTags,
      countriesTagsInLanguages: <OpenFoodFactsLanguage, List<String>>{
        language: product.countryTags,
      },
      lang: language,
      quantity: product.quantity,
      ingredients: product.ingredientList
          .mapIndexed(
            (int rank, String ingredient) => Ingredient(
              rank: rank,
              text: ingredient,
              vegan: product.isVegan
                  ? IngredientSpecialPropertyStatus.POSITIVE
                  : IngredientSpecialPropertyStatus.IGNORE,
              vegetarian: product.isVegetarian
                  ? IngredientSpecialPropertyStatus.POSITIVE
                  : IngredientSpecialPropertyStatus.IGNORE,
            ),
          )
          .toList(),
      ingredientsText: ingredientsText,
      ingredientsTextInLanguages: <OpenFoodFactsLanguage, String>{
        language: ingredientsText,
      },
      categories: product.countryTags.join(','),
      categoriesTags: product.categoryTags,
      categoriesTagsInLanguages: <OpenFoodFactsLanguage, List<String>>{
        language: product.categoryTags,
      },
      packaging: product.packaging,
      packagingTags: <String>[product.packaging],
    );

    // Save the extracted ingredients to the product on the OFF server
    results = await OpenFoodAPIClient.saveProduct(
      user,
      editedProduct,
    );

    if (results.status != 1) {
      throw Exception('product could not be added');
    }

    //Get The saved product's ingredients from the server
    final ProductQueryConfiguration configurations = ProductQueryConfiguration(
      photo.info.barcode,
      language: language,
      fields: <ProductField>[
        ProductField.INGREDIENTS_TEXT,
      ],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 productResult = await OpenFoodAPIClient.getProductV3(
      configurations,
      user: user,
    );

    if (productResult.status != ProductResultV3.statusSuccess) {
      throw Exception(
        'product not found, please insert data for ${photo.info.barcode}',
      );
    }
  }
}
