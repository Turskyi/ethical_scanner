import 'package:entities/entities.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

extension ProductExtension on Product {
  ProductInfo toProductInfo() {
    return ProductInfo(
      barcode: barcode ?? '',
      origin: ((origins == null || origins?.isEmpty == true) &&
              (barcode?.isNotEmpty == true) &&
              (barcode?.startsWith('460') == true))
          ? translate('product_info.russian')
          : origins ?? '',
      countrySold: _countryName,
      countryTags: _countryNames,
      name: productName ?? '',
      brand: brands ?? '',
      categoryTags: _categories,
      packaging: packaging ?? '',
      ingredientList: _ingredientNames,
      vegan: _vegan,
      vegetarian: _vegetarian,
      website: website ?? '',
      imageIngredientsUrl: imageIngredientsUrl ?? '',
    );
  }

  String get _countryName {
    if (countries != null && countries!.isNotEmpty) {
      if (countries!.contains(':')) {
        final String countryName = countries!.split(':')[1];
        return countryName[0].toUpperCase() + countryName.substring(1);
      }
      return countries!;
    } else {
      return _countryNames.isNotEmpty ? _countryNames.first : '';
    }
  }

  List<String> get _countryNames =>
      countriesTags?.map((String countryTag) {
        if (countryTag.contains(':')) {
          final String countryName = countryTag.split(':')[1];
          return countryName[0].toUpperCase() + countryName.substring(1);
        }
        return countryTag;
      }).toList() ??
      <String>[];

  List<String> get _categories =>
      categoriesTags?.map((String categoryTag) {
        if (categoryTag.contains(':')) {
          final String categoryName = categoryTag.split(':')[1];
          return categoryName;
        }
        return categoryTag;
      }).toList() ??
      <String>[];

  List<String> get _ingredientNames {
    if (_isUnknownIngredients) {
      return <String>[];
    } else {
      return ingredients!.map((Ingredient ingredient) {
        if (ingredient.text != null && ingredient.text!.isNotEmpty) {
          return ingredient.text!;
        } else if (ingredient.id != null && ingredient.id!.contains(':')) {
          return ingredient.id!.split(':')[1];
        } else {
          return ingredient.id ?? '';
        }
      }).toList();
    }
  }

  Vegan get _vegan {
    if (ingredientsAnalysisTags?.veganStatus == VeganStatus.VEGAN) {
      return Vegan.positive;
    } else if (_isNonVeganStatus) {
      return Vegan.negative;
    } else if (_isUnknownIngredients || _isUnknownVeganStatus) {
      return Vegan.unknown;
    } else {
      final bool isVegan = ingredients!.every((Ingredient ingredient) {
        return ingredient.vegan == IngredientSpecialPropertyStatus.POSITIVE;
      });
      return isVegan ? Vegan.positive : Vegan.negative;
    }
  }

  Vegetarian get _vegetarian {
    if (ingredientsAnalysisTags?.vegetarianStatus ==
        VegetarianStatus.VEGETARIAN) {
      return Vegetarian.positive;
    } else if (_isNonVegetarianStatus) {
      return Vegetarian.negative;
    } else if (_isUnknownIngredients || _isUnknownVegetarianStatus) {
      return Vegetarian.unknown;
    } else {
      final bool isVegetarian = ingredients!.every((Ingredient ingredient) {
        return ingredient.vegetarian ==
            IngredientSpecialPropertyStatus.POSITIVE;
      });
      return isVegetarian ? Vegetarian.positive : Vegetarian.negative;
    }
  }

  bool get _isUnknownIngredients => ingredients == null || ingredients!.isEmpty;

  bool get _isUnknownVeganStatus => ingredients!.any(
        (Ingredient ingredient) =>
            ingredient.vegan == null ||
            ingredient.vegan == IngredientSpecialPropertyStatus.IGNORE ||
            ingredient.vegan == IngredientSpecialPropertyStatus.MAYBE,
      );

  bool get _isUnknownVegetarianStatus => ingredients!.any(
        (Ingredient ingredient) =>
            ingredient.vegetarian == null ||
            ingredient.vegetarian == IngredientSpecialPropertyStatus.IGNORE ||
            ingredient.vegetarian == IngredientSpecialPropertyStatus.MAYBE,
      );

  bool get _isNonVeganStatus =>
      ingredientsAnalysisTags?.veganStatus == VeganStatus.NON_VEGAN ||
      (ingredients != null &&
          ingredients!.any(
            (Ingredient ingredient) =>
                ingredient.vegan == IngredientSpecialPropertyStatus.NEGATIVE,
          ));

  bool get _isNonVegetarianStatus =>
      ingredientsAnalysisTags?.vegetarianStatus ==
          VegetarianStatus.NON_VEGETARIAN ||
      (ingredients != null &&
          ingredients!.any(
            (Ingredient ingredient) =>
                ingredient.vegetarian ==
                IngredientSpecialPropertyStatus.NEGATIVE,
          ));
}
