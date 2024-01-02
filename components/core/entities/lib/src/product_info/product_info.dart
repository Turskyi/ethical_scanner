import 'package:entities/src/enums/vegan.dart';
import 'package:entities/src/enums/vegetarian.dart';

class ProductInfo {
  const ProductInfo({
    this.barcode = '',
    this.origin = '',
    this.countryTags = const <String>[],
    this.country = '',
    this.name = '',
    this.brand = '',
    this.categoryTags = const <String>[],
    this.packaging = '',
    this.ingredientList = const <String>[],
    this.vegan = Vegan.unknown,
    this.vegetarian = Vegetarian.unknown,
    this.website = '',
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
  final String name;
  final String brand;

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

  ProductInfo copyWith({
    String? barcode,
    String? origin,
    List<String>? countryTags,
    String? country,
    String? name,
    String? brand,
    List<String>? categoryTags,
    String? packaging,
    List<String>? ingredientList,
    Vegan? vegan,
    Vegetarian? vegetarian,
    String? website,
  }) =>
      ProductInfo(
        barcode: barcode ?? this.barcode,
        origin: origin ?? this.origin,
        countryTags: countryTags ?? this.countryTags,
        country: country ?? this.country,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        categoryTags: categoryTags ?? this.categoryTags,
        packaging: packaging ?? this.packaging,
        ingredientList: ingredientList ?? this.ingredientList,
        vegan: vegan ?? this.vegan,
        vegetarian: vegetarian ?? this.vegetarian,
        website: website ?? this.website,
      );
}
