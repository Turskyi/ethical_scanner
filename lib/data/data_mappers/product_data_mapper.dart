import 'package:entities/entities.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

extension ProductExtension on Product {
  ProductInfo toProductInfo() => ProductInfo(
        barcode: barcode ?? '',
        origin: origins ?? '',
        country: countryName,
        countryTags: countryNames,
        name: productName ?? '',
        brand: brands ?? '',
        categoryTags: categories,
        packaging: packaging ?? '',
        ingredientList: ingredientNames,
        vegan: vegan,
        vegetarian: vegetarian,
        website: website ?? '',
      );

  String get countryName {
    if (_hasCountries) {
      return countries!;
    } else {
      return countryNames.isNotEmpty ? countryNames.first : '';
    }
  }

  List<String> get countryNames {
    return countriesTags?.map((String countryTag) {
          if (countryTag.contains(':')) {
            String countryName = countryTag.split(':')[1];
            return countryName[0].toUpperCase() + countryName.substring(1);
          }
          return countryTag;
        }).toList() ??
        <String>[];
  }

  List<String> get categories {
    return categoriesTags?.map((String categoryTag) {
          if (categoryTag.contains(':')) {
            String categoryName = categoryTag.split(':')[1];
            return categoryName;
          }
          return categoryTag;
        }).toList() ??
        <String>[];
  }

  List<String> get ingredientNames {
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

  Vegan get vegan {
    if (ingredientsAnalysisTags?.veganStatus == VeganStatus.VEGAN) {
      return Vegan.positive;
    } else if (_isNonVeganStatus) {
      return Vegan.negative;
    } else if (_isUnknownIngredients || _isUnknownVeganStatus) {
      return Vegan.unknown;
    } else {
      bool isVegan = ingredients!.every((Ingredient ingredient) {
        return ingredient.vegan == IngredientSpecialPropertyStatus.POSITIVE;
      });
      return isVegan ? Vegan.positive : Vegan.negative;
    }
  }

  Vegetarian get vegetarian {
    if (ingredientsAnalysisTags?.vegetarianStatus ==
        VegetarianStatus.VEGETARIAN) {
      return Vegetarian.positive;
    } else if (_isNonVegetarianStatus) {
      return Vegetarian.negative;
    } else if (_isUnknownIngredients || _isUnknownVegetarianStatus) {
      return Vegetarian.unknown;
    } else {
      bool isVegetarian = ingredients!.every((Ingredient ingredient) {
        return ingredient.vegetarian ==
            IngredientSpecialPropertyStatus.POSITIVE;
      });
      return isVegetarian ? Vegetarian.positive : Vegetarian.negative;
    }
  }

  bool get _hasCountries {
    return countries != null && countries!.isNotEmpty;
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
      ingredients!.any(
        (Ingredient ingredient) =>
            ingredient.vegan == IngredientSpecialPropertyStatus.NEGATIVE,
      );

  bool get _isNonVegetarianStatus =>
      ingredientsAnalysisTags?.vegetarianStatus ==
          VegetarianStatus.NON_VEGETARIAN ||
      ingredients!.any(
        (Ingredient ingredient) =>
            ingredient.vegetarian == IngredientSpecialPropertyStatus.NEGATIVE,
      );
}
