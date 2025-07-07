import 'package:collection/collection.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_mappers/language_data_mapper.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

extension ProductExtension on Product {
  ProductInfo toProductInfo(Language language) {
    return ProductInfo(
      barcode: barcode ?? '',
      origin: _origin,
      countrySold: _countryName,
      countryTags: _countryNames,
      name: _getProductName(language),
      brand: brands ?? '',
      categoryTags: _categories,
      packaging: packaging ?? '',
      ingredientList: _getIngredientNames(language),
      vegan: _vegan,
      vegetarian: _vegetarian,
      website: website ?? '',
      imageIngredientsUrl: imageIngredientsUrl ?? '',
    );
  }

  String get _origin {
    return ((origins == null || origins?.isEmpty == true) &&
            (barcode?.isNotEmpty == true) &&
            (barcode?.startsWith('460') == true))
        ? translate('product_info.russian')
        : origins ?? '';
  }

  String _getProductName(Language language) {
    if (productNameInLanguages != null &&
        productNameInLanguages?.isNotEmpty == true &&
        productNameInLanguages?.keys.any(
              (OpenFoodFactsLanguage languageKey) {
                return Language.values.any((Language appLanguage) {
                  return appLanguage.toOpenFoodFactsLanguage == languageKey;
                });
              },
            ) ==
            true) {
      final OpenFoodFactsLanguage targetOpenFoodFactsLanguage =
          language.toOpenFoodFactsLanguage;
      if (productNameInLanguages?.containsKey(targetOpenFoodFactsLanguage) ==
          true) {
        final String? localizedProductName =
            productNameInLanguages?[targetOpenFoodFactsLanguage];

        if (localizedProductName != null && localizedProductName.isNotEmpty) {
          return localizedProductName;
        }
      } else {
        // Try the first available name from a language key that matches one of
        // our app's Language enums.
        final MapEntry<OpenFoodFactsLanguage, String>? firstSupportedEntry =
            productNameInLanguages!.entries.firstWhereOrNull(
          (MapEntry<OpenFoodFactsLanguage, String> entry) {
            final bool isSupportedAppLanguage =
                Language.values.any((Language appLang) {
              return appLang.toOpenFoodFactsLanguage == entry.key;
            });
            return isSupportedAppLanguage && entry.value.isNotEmpty;
          },
        );

        if (firstSupportedEntry != null) {
          return firstSupportedEntry.value;
        }
      }
    }

    return productName ?? '';
  }

  String get _countryName {
    if (countries != null && countries?.isNotEmpty == true) {
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

  List<String> get _categories {
    return categoriesTags?.map((String categoryTag) {
          if (categoryTag.contains(':')) {
            final String categoryName = categoryTag.split(':')[1];
            return categoryName;
          }
          return categoryTag;
        }).toList() ??
        <String>[];
  }

  List<String> _getIngredientNames(Language language) {
    if (_isUnknownIngredients) {
      return <String>[];
    } else if (ingredientsTextInLanguages != null &&
        ingredientsTextInLanguages?.isNotEmpty == true &&
        ingredientsTextInLanguages?.keys.any(
              (OpenFoodFactsLanguage languageKey) {
                return Language.values.any((Language appLanguage) {
                  return appLanguage.toOpenFoodFactsLanguage == languageKey;
                });
              },
            ) ==
            true) {
      final OpenFoodFactsLanguage targetOffLanguage =
          language.toOpenFoodFactsLanguage;
      String? localizedIngredientsText;

      // 1. Try to get the ingredients string for the requested language.
      if (ingredientsTextInLanguages?.containsKey(targetOffLanguage) == true) {
        localizedIngredientsText =
            ingredientsTextInLanguages?[targetOffLanguage];
      }

      // 2. If not available, try the first available language from a supported
      // app language.
      if (localizedIngredientsText == null ||
          localizedIngredientsText.isEmpty) {
        final MapEntry<OpenFoodFactsLanguage, String>? firstSupportedEntry =
            ingredientsTextInLanguages?.entries.firstWhereOrNull(
          (MapEntry<OpenFoodFactsLanguage, String> entry) {
            final bool isSupportedAppLanguage =
                Language.values.any((Language appLang) {
              return appLang.toOpenFoodFactsLanguage == entry.key;
            });
            return isSupportedAppLanguage && entry.value.isNotEmpty;
          },
        );

        if (firstSupportedEntry != null) {
          localizedIngredientsText = firstSupportedEntry.value;
        }
      }

      // 3. If a string was found, split it by comma and trim.
      if (localizedIngredientsText != null &&
          localizedIngredientsText.isNotEmpty) {
        final List<String> parsedIngredients = localizedIngredientsText
            .split(',')
            .map((String ingredient) => ingredient.trim())
            .where((String ingredient) => ingredient.isNotEmpty)
            .toList();
        // If parsing resulted in a non-empty list, return it.
        // Otherwise, we'll fall through to the structured ingredients list.
        if (parsedIngredients.isNotEmpty) {
          return parsedIngredients;
        }
      }
    }
    return ingredients?.map((Ingredient ingredient) {
          final String? ingredientText = ingredient.text;

          final String? ingredientId = ingredient.id;

          if (ingredientText != null && ingredientText.isNotEmpty) {
            return ingredientText;
          } else if (ingredientId != null && ingredientId.contains(':')) {
            return ingredientId.split(':')[1];
          } else {
            return ingredientId ?? '';
          }
        }).toList() ??
        <String>[];
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
