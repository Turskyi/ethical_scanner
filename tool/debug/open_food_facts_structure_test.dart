import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

/// Debug tool to fetch and inspect the full product data structure returned
/// from the OpenFoodFacts API for a given barcode.
///
/// Run this test tool using:
/// ```sh
/// flutter test tool/debug/open_food_facts_structure_test.dart
/// ```
void main() {
  if (kDebugMode) {
    test('fetches and inspects full OpenFoodFacts data structure for barcode '
        '062020023131', () async {
      const String targetBarcode = '062020023131';

      OpenFoodAPIConfiguration.globalUser = const User(
        userId: 'EthicalScannerDebugTool',
        password: '',
      );
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'EthicalScannerDebug',
      );

      final ProductQueryConfiguration configuration = ProductQueryConfiguration(
        targetBarcode,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: <ProductField>[ProductField.ALL],
        version: ProductQueryVersion.v3,
      );

      final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(
        configuration,
      );

      debugPrint('=== OPEN FOOD FACTS FULL PRODUCT DATA STRUCTURE ===');
      debugPrint('Barcode: $targetBarcode');
      debugPrint('Status Code: ${result.status}');

      final Product? product = result.product;
      if (product != null) {
        debugPrint('\n--- BASIC DETAILS ---');
        debugPrint('Product Name: ${product.productName}');
        debugPrint('Brands: ${product.brands}');
        debugPrint('Quantity: ${product.quantity}');
        debugPrint('Categories: ${product.categoriesTags}');

        debugPrint('\n--- ETHICAL & ENVIRONMENTAL DATA ---');
        debugPrint('Eco-Score Grade: ${product.ecoscoreGrade}');
        debugPrint('Eco-Score Score: ${product.ecoscoreScore}');
        debugPrint('Eco-Score Data: ${product.ecoscoreData}');

        debugPrint('\n--- INGREDIENTS & ETHICAL ANALYSIS ---');
        debugPrint('Ingredients Text: ${product.ingredientsText}');
        debugPrint(
          'Ingredients Analysis Tags: ${product.ingredientsAnalysisTags}',
        );
        debugPrint('Allergens: ${product.allergens}');
        debugPrint('Additives: ${product.additives}');

        debugPrint('\n--- CERTIFICATIONS, LABELS & ORIGIN ---');
        debugPrint('Labels Tags: ${product.labelsTags}');
        debugPrint('Origins: ${product.origins}');
        debugPrint('Manufacturing Places: ${product.manufacturingPlaces}');
        debugPrint('Countries Tags: ${product.countriesTags}');
        debugPrint('Stores Tags: ${product.storesTags}');

        debugPrint('\n--- PACKAGING & RECYCLABILITY ---');
        debugPrint('Packaging Tags: ${product.packagingTags}');
        debugPrint('Packagings: ${product.packagings}');

        debugPrint('\n--- NUTRITION & HEALTH ---');
        debugPrint('Nutriscore Grade: ${product.nutriscore}');
        debugPrint('Nutriments: ${product.nutriments}');
      } else {
        debugPrint(
          'No product details found for barcode $targetBarcode in '
          'OpenFoodFacts database.',
        );
      }

      expect(result, isNotNull);
    }, timeout: const Timeout(Duration(seconds: 60)));
  }
}
