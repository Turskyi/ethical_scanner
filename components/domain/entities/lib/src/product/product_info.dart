import 'package:entities/src/enums/language.dart';
import 'package:entities/src/enums/product_response_type.dart';
import 'package:entities/src/enums/vegan.dart';
import 'package:entities/src/enums/vegetarian.dart';

class ProductInfo {
  const ProductInfo({
    this.barcode = '',
    this.origin = '',
    this.gs1Country = '',
    this.reportedOrigin = '',
    this.countryTags = const <String>[],
    this.countrySold = '',
    this.infoAi = '',
    this.infoAiModel = '',
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
    this.responseType = ProductResponseType.openFoodFacts,
    this.leaveRussiaUrl = '',
  });

  final String barcode;

  /// The [origin] parameter is a string that indicates the origin of
  /// ingredients of the product. For example, [origin]=Apples from France,
  /// Flour from Canada.
  final String origin;

  /// The [gs1Country] parameter is the country associated with the GS1 prefix
  /// of the barcode. It indicates which GS1 Member Organization's country
  /// registered the barcode — not where the product was manufactured.
  final String gs1Country;

  /// The [reportedOrigin] parameter is a manually curated, evidence-based
  /// country of origin derived from physical product observations tied to
  /// specific barcode prefixes.
  final String reportedOrigin;

  /// The [countryTags] parameter is a list of strings that indicates the
  /// countries where the product is sold. For example, [countryTags]=France,
  /// Germany.
  final List<String> countryTags;

  /// The [countrySold] parameter is a string that indicates the country where
  /// the product is sold. For example, [countrySold]=France. It is similar to
  /// the [countriesTags] parameter, but it uses the common names of the
  /// countries instead of the language codes. However, the countriesTags
  /// parameter is more reliable and consistent, as it follows the
  /// [ISO 3166-1 alpha-2] standard. Therefore, it is recommended to use the
  /// [countriesTags] parameter over the countries parameter for filtering and
  /// sorting the products.
  final String countrySold;
  final String infoAi;
  final String infoAiModel;
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
  final ProductResponseType responseType;

  /// The company-specific Leave Russia / KSE Institute profile page URL
  /// (e.g., `https://leave-russia.org/ferrero` or
  /// `https://leave-russia.org/uk/ferrero`).
  ///
  /// When a barcode lookup successfully identifies a company on Leave Russia,
  /// this URL is populated with the company's dedicated page. When tapped in
  /// the UI, it opens this company page instead of the generic site-wide source
  /// link.
  final String leaveRussiaUrl;

  /// EAN barcode prefix for Russia (barcodes starting with '46').
  static const String russianBarcodePrefix = '46';
  static const String russianEanPrefix = '460';

  bool get isVegan => vegan == Vegan.positive;

  bool get isVegetarian => vegetarian == Vegetarian.positive;

  bool get isFromRussia =>
      countrySold.toLowerCase() == 'russia' ||
      countrySold.toLowerCase() == 'ru' ||
      origin.toLowerCase() == 'russia' ||
      origin.toLowerCase() == 'ru' ||
      countrySold.toLowerCase() == 'россия' ||
      origin.toLowerCase() == 'россия' ||
      barcode.startsWith(russianEanPrefix);

  /// US State Department designated state sponsors of terrorism.
  /// Source: https://www.state.gov/state-sponsors-of-terrorism/
  static const Set<String> _stateSponsoredTerrorismCountries = <String>{
    'Cuba',
    'North Korea',
    'Iran',
    'Syria',
  };

  bool get isGs1CountryStateSponsorOfTerrorism =>
      _stateSponsoredTerrorismCountries.contains(gs1Country);

  ProductInfo copyWith({
    String? barcode,
    String? origin,
    String? gs1Country,
    String? reportedOrigin,
    List<String>? countryTags,
    String? countrySold,
    String? infoAi,
    String? infoAiModel,
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
    ProductResponseType? responseType,
    String? leaveRussiaUrl,
  }) {
    return ProductInfo(
      barcode: barcode ?? this.barcode,
      origin: origin ?? this.origin,
      gs1Country: gs1Country ?? this.gs1Country,
      reportedOrigin: reportedOrigin ?? this.reportedOrigin,
      countryTags: countryTags ?? this.countryTags,
      countrySold: countrySold ?? this.countrySold,
      infoAi: infoAi ?? this.infoAi,
      infoAiModel: infoAiModel ?? this.infoAiModel,
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
      responseType: responseType ?? this.responseType,
      leaveRussiaUrl: leaveRussiaUrl ?? this.leaveRussiaUrl,
    );
  }

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
        'country: $countrySold, '
        'countryAi: $infoAi, '
        'infoAiModel: $infoAiModel, '
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
        'imageIngredientsUrl: $imageIngredientsUrl,'
        'responseType: $responseType,'
        'leaveRussiaUrl: $leaveRussiaUrl'
        '}';
  }
}
