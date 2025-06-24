import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_mappers/product_data_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  group('Product Extension', () {
    test('To ProductInfo', () {
      // Arrange
      final Product product = Product(
        barcode: '123456789',
        productName: 'Product Name',
        brands: 'Brand',
        categoriesTags: <String>['category:Category'],
        packaging: 'Packaging',
        ingredients: <Ingredient>[
          Ingredient(
            text: 'Ingredient 1',
            vegan: IngredientSpecialPropertyStatus.POSITIVE,
          ),
          Ingredient(
            text: 'Ingredient 2',
            vegan: IngredientSpecialPropertyStatus.POSITIVE,
          ),
        ],
        ingredientsAnalysisTags: IngredientsAnalysisTags(
          <Object?>[VeganStatus.VEGAN],
        ),
      );

      // Act
      final ProductInfo productInfo = product.toProductInfo(Language.en);

      // Assert
      expect(productInfo.barcode, '123456789');
      expect(productInfo.name, 'Product Name');
      expect(productInfo.brand, 'Brand');
      expect(productInfo.categoryTags, <String>['Category']);
      expect(productInfo.packaging, 'Packaging');
      expect(
        productInfo.ingredientList,
        <String>['Ingredient 1', 'Ingredient 2'],
      );
      expect(productInfo.vegan, Vegan.positive);
      expect(productInfo.vegetarian, Vegetarian.unknown);
    });
  });
}
