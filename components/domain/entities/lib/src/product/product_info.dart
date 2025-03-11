import 'package:entities/src/enums/language.dart';
import 'package:entities/src/enums/vegan.dart';
import 'package:entities/src/enums/vegetarian.dart';

class ProductInfo {
  const ProductInfo({
    this.barcode = '',
    this.origin = '',
    this.countryTags = const <String>[],
    this.country = '',
    this.countryAi = '',
    this.name = '',
    this.brand = '',
    this.isCompanyTerrorismSponsor = false,
    this.categoryTags = const <String>[],
    this.packaging = '',
    this.ingredientList = const <String>[],
    this.vegan = Vegan.unknown,
    this.vegetarian = Vegetarian.unknown,
    this.website = '',
    this.language = Language.en,
    this.quantity = '',
    this.imageIngredientsUrl = '',
  });

  final String barcode;

  /// The [origin] parameter is a string that indicates the origin of
  /// ingredients of the product. For example, [origin]=Apples from France,
  /// Flour from Canada.
  final String origin;

  /// The [countryTags] parameter is a list of strings that indicates the
  /// countries where the product is sold. For example, [countryTags]=France,
  /// Germany.
  final List<String> countryTags;

  /// The [country] parameter is a string that indicates the country where the
  /// product is sold. For example, [country]=France. It is similar to the
  /// [countriesTags] parameter, but it uses the common names of the countries
  /// instead of the language codes. However, the countriesTags parameter is
  /// more reliable and consistent, as it follows the [ISO 3166-1 alpha-2]
  /// standard. Therefore, it is recommended to use the [countriesTags]
  /// parameter over the countries parameter for filtering and sorting the
  /// products.
  final String country;
  final String countryAi;
  final String name;
  final String brand;
  final bool isCompanyTerrorismSponsor;

  /// The [categoryTags] parameter is a list of strings that indicates the
  /// categories of the product. For example,
  /// [categoryTags]=plant-based-foods-and-beverages,plant-based-foods,
  /// cereals-and-potatoes, breads.
  final List<String> categoryTags;
  final String packaging;
  final List<String> ingredientList;
  final Vegan vegan;
  final Vegetarian vegetarian;
  final String website;
  final Language language;
  final String quantity;
  final String imageIngredientsUrl;

  bool get isVegan => vegan == Vegan.positive;

  bool get isVegetarian => vegetarian == Vegetarian.positive;

  bool get isFromRussia =>
      country.toLowerCase() == 'russia' ||
      country.toLowerCase() == 'ru' ||
      origin.toLowerCase() == 'russia' ||
      origin.toLowerCase() == 'ru' ||
      country.toLowerCase() == 'россия' ||
      origin.toLowerCase() == 'россия';

  ProductInfo copyWith({
    String? barcode,
    String? origin,
    List<String>? countryTags,
    String? country,
    String? countryAi,
    String? name,
    String? brand,
    bool? isCompanyTerrorismSponsor,
    List<String>? categoryTags,
    String? packaging,
    List<String>? ingredientList,
    Vegan? vegan,
    Vegetarian? vegetarian,
    String? website,
    Language? language,
    String? quantity,
    String? imageIngredientsUrl,
  }) =>
      ProductInfo(
        barcode: barcode ?? this.barcode,
        origin: origin ?? this.origin,
        countryTags: countryTags ?? this.countryTags,
        country: country ?? this.country,
        countryAi: countryAi ?? this.countryAi,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        isCompanyTerrorismSponsor:
            isCompanyTerrorismSponsor ?? this.isCompanyTerrorismSponsor,
        categoryTags: categoryTags ?? this.categoryTags,
        packaging: packaging ?? this.packaging,
        ingredientList: ingredientList ?? this.ingredientList,
        vegan: vegan ?? this.vegan,
        vegetarian: vegetarian ?? this.vegetarian,
        website: website ?? this.website,
        language: language ?? this.language,
        quantity: quantity ?? this.quantity,
        imageIngredientsUrl: imageIngredientsUrl ?? this.imageIngredientsUrl,
      );

  bool get isEnglishBook {
    final List<int> digits = barcode.codeUnits
        .where((int char) => char >= 48 && char <= 57)
        .map((int char) => char - 48)
        .toList();

    if (digits.length != 13) {
      return false;
    }

    // Check if it starts with "978" (common Book-land prefix).
    if (digits.sublist(0, 3).join() != '978') {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'ProductInfo{'
        'barcode: $barcode, '
        'origin: $origin, '
        'countryTags: $countryTags, '
        'country: $country, '
        'countryAi: $countryAi, '
        'name: $name, '
        'brand: $brand, '
        'isTerrorismSponsor: '
        '$isCompanyTerrorismSponsor, '
        'categoryTags: $categoryTags, '
        'packaging: $packaging, '
        'ingredientList: $ingredientList, '
        'vegan: $vegan, '
        'vegetarian: $vegetarian, '
        'website: $website, '
        'language: ${language.name}, '
        'quantity: $quantity,'
        '}';
  }
}
