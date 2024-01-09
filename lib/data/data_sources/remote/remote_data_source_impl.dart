import 'package:dart_openai/dart_openai.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_mappers/product_data_mapper.dart';
import 'package:ethical_scanner/data/data_mappers/product_result_data_mapper.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  const RemoteDataSourceImpl();

  @override
  Future<ProductInfo> getProductInfoAsFuture(String input) =>
      OpenFoodAPIClient.getProductV3(
        ProductQueryConfiguration(
          input,
          language: OpenFoodFactsLanguage.ENGLISH,
          fields: <ProductField>[ProductField.ALL],
          version: ProductQueryVersion.v3,
        ),
      ).then((ProductResultV3 result) {
        if (result.product != null && result.hasSuccessfulStatus) {
          return result.product!.toProductInfo();
        } else if (result.status == ProductResultV3.statusFailure) {
          if (_isBarcode(input)) {
            return ProductInfo(barcode: input);
          } else if (_isWebsite(input)) {
            return ProductInfo(website: input);
          } else if (_isAmazonAsin(input)) {
            return const ProductInfo(brand: 'Amazon');
          }
        }
        throw Exception(
          'Product information not found for barcode: $input',
        );
      });

  @override
  Future<String> getCountryFromAiAsFuture(String barcode) =>
      OpenAI.instance.chat.create(
        model: 'gpt-4',
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
        String? country = completion
            .choices.firstOrNull?.message.content?.firstOrNull?.text
            ?.trim();
        return country ?? '';
      }).onError((_, __) {
        return '';
      });

  /// Extract the ingredients of an existing product of the OpenFoodFacts
  /// database that has already ingredient image otherwise it should be added
  /// first to the server and then this can be called.
  @override
  Future<String> getIngredientsText(String barcode) =>
      OpenFoodAPIClient.extractIngredients(
        const User(
          userId: 'dmytro@turskyi.com',
          password: '',
        ),
        barcode,
        OpenFoodFactsLanguage.ENGLISH,
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
    // ASIN pattern: A followed by 10 characters, typically alphanumeric
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
