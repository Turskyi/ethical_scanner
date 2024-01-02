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
        if (result.isNonNullProductSuccessful) {
          return result.product!.toProductInfo();
        } else if (result.status == ProductResultV3.statusFailure) {
          if (_isBarcode(input)) {
            return ProductInfo(barcode: input);
          } else if (_isWebsite(input)) {
            return ProductInfo(website: input);
          }
        }
        throw Exception(
          'Product information not found for barcode: $input',
        );
      });

  /// Extract the ingredients of an existing product of the OpenFoodFacts
  /// database that has already ingredient image otherwise it should be added
  /// first to the server and then this can be called.
  @override
  Future<String> getIngredientsText(String barcode) async {
    // A registered user login for https://world.openfoodfacts.org is required.
    const User user = User(
      userId: 'dmytro@turskyi.com',
      password: '',
    );
    // Query the OpenFoodFacts API.
    OcrIngredientsResult response = await OpenFoodAPIClient.extractIngredients(
      user,
      barcode,
      OpenFoodFactsLanguage.ENGLISH,
    );
    if (response.status != 0) {
      return '';
    }
    return response.ingredientsTextFromImage ?? '';
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

  bool _isWebsite(String input) {
    // Regular expression for URL validation
    final RegExp regex = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]'
      r'{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
    );
    return regex.hasMatch(input);
  }
}
