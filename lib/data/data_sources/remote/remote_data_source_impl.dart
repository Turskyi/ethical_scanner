import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_mappers/product_data_mapper.dart';
import 'package:ethical_scanner/data/data_mappers/product_result_data_mapper.dart';
import 'package:ethical_scanner/res/values/constants.dart' as constants;
import 'package:interface_adapters/interface_adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  const RemoteDataSourceImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode input) =>
      OpenFoodAPIClient.getProductV3(
        ProductQueryConfiguration(
          input.code,
          language: OpenFoodFactsLanguage.ENGLISH,
          fields: <ProductField>[ProductField.ALL],
          version: ProductQueryVersion.v3,
        ),
      ).then((ProductResultV3 result) {
        if (result.product != null && result.hasSuccessfulStatus) {
          ProductInfo product = result.product!.toProductInfo();
          if (product.brand.isNotEmpty || product.name.isNotEmpty) {
            return _restClient
                .getTerrorismSponsors()
                .then((List<TerrorismSponsor> terrorismSponsors) {
              return product.copyWith(
                isCompanyTerrorismSponsor: terrorismSponsors.sponsoredBy(
                  product,
                ),
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
    Product newProduct = Product(
      barcode: product.barcode,
      productName: product.name,
      genericName: product.name,
      brands: product.brand,
      brandsTags: <String>[product.brand],
      countries: product.country,
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

    Status result = await OpenFoodAPIClient.saveProduct(
      OpenFoodAPIConfiguration.globalUser ??
          const User(
            userId: Env.openFoodUserId,
            password: Env.openFoodPassword,
            comment: constants.openFoodUserComment,
          ),
      newProduct,
    );

    if (result.status == HttpStatus.badRequest) {
      throw BadRequestError(
        result.body != null
            ? '${result.body}'
            : 'Product could not be added.\n${result.error ?? ''}',
      );
    } else if (result.status != 1) {
      throw Exception(
        'product could not be added ${result.error ?? ''}',
      );
    }
  }

  @override
  Future<void> addIngredients(ProductPhoto photo) async {
    SendImage image = SendImage(
      barcode: photo.info.barcode,
      imageUri: Uri.parse(photo.path),
      imageField: ImageField.INGREDIENTS,
    );

    Status status = await OpenFoodAPIClient.addProductImage(
      OpenFoodAPIConfiguration.globalUser ??
          const User(
            userId: Env.openFoodUserId,
            password: Env.openFoodPassword,
            comment: constants.openFoodUserComment,
          ),
      image,
    );
    if (status.status == HttpStatus.internalServerError) {
      throw InternalServerError(
        'Image could not be uploaded: ${status.error}.\n'
        '${status.imageId != null ? status.imageId.toString() : ''}',
      );
    } else if (status.status != 'status ok') {
      throw Exception(
        'image could not be uploaded: ${status.error}.\n'
        '${status.imageId != null ? status.imageId.toString() : ''}',
      );
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

  /// Extract the ingredients of an existing product of the OpenFoodFacts
  /// database that does not have ingredient image and then save it back to the
  /// OFF server.
  Future<void> saveAndExtractIngredient(ProductPhoto photo) async {
    // A registered user login for https://world.openfoodfacts.org/ is required.
    User user = OpenFoodAPIConfiguration.globalUser ??
        const User(
          userId: Env.openFoodUserId,
          password: Env.openFoodPassword,
          comment: constants.openFoodUserComment,
        );
    OpenFoodFactsLanguage language = photo.info.language.isEnglish
        ? OpenFoodFactsLanguage.ENGLISH
        : OpenFoodFactsLanguage.UKRAINIAN;
    SendImage image = SendImage(
      barcode: photo.info.barcode,
      imageUri: Uri.parse(photo.path),
      imageField: ImageField.INGREDIENTS,
    );

    //Add the ingredients image to the server
    Status results = await OpenFoodAPIClient.addProductImage(user, image);

    if (results.status == null) {
      throw Exception('Adding image failed');
    }

    OcrIngredientsResult ocrResponse =
        await OpenFoodAPIClient.extractIngredients(
      user,
      photo.info.barcode,
      language,
    );

    if (ocrResponse.status != 0) {
      throw Exception("Text can't be extracted.");
    }

    ProductInfo product = photo.info;
    String ingredientsText = ocrResponse.ingredientsTextFromImage ??
        photo.info.ingredientList.join(',');
    Product editedProduct = Product(
      barcode: product.barcode,
      productName: product.name,
      productNameInLanguages: <OpenFoodFactsLanguage, String>{
        language: product.name,
      },
      genericName: product.name,
      brands: product.brand,
      brandsTags: <String>[product.brand],
      countries: product.country,
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
    RegExp asinPattern = RegExp(r'^[A-Z0-9]{10}$');
    return asinPattern.hasMatch(barcode);
  }

  bool _isBarcode(String input) {
    // Typical barcodes are between 8 and 14 digits long
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
}
