import 'package:entities/entities.dart';

abstract interface class TerrorismSponsor {
  const TerrorismSponsor({
    required this.id,
    required this.status,
    required this.name,
    required this.brands,
  });

  final String id;
  final String status;
  final String name;
  final String brands;
}

extension TerrorismSponsorList on List<TerrorismSponsor> {
  bool sponsoredBy(ProductInfo product) {
    final bool isSponsoredByOtherRussiaSponsors =
        _isSponsoredByOtherRussiaSponsors(product);

    return isSponsoredByOtherRussiaSponsors ||
        _isSponsoredByAnyTerrorismSponsor(product);
  }

  List<String> get _otherTerrorismSponsors => <String>[
        // added to response
        'quaker',
        'nestlé',
        'pepsi cola',
        'mars inc.',
        // not added, as it looks like exception
        'bacardi, martini',
        'quakerquaker oats',
        'bounty chocolate',
      ];

  bool _isSponsoredByOtherRussiaSponsors(ProductInfo product) {
    final String productBrandString = product.brand.toLowerCase().trim();

    if (productBrandString.isEmpty) {
      return false;
    }

    // Split the product's brand string by comma, trim whitespace,
    // and remove empty strings.
    final List<String> productIndividualBrands = productBrandString
        .split(',')
        .map((String brand) => brand.trim())
        .where((String brand) => brand.isNotEmpty)
        .toList();

    // Check if any of the product's individual brands are present in the
    // _otherTerrorismSponsors list.
    for (final String pBrand in productIndividualBrands) {
      if (_otherTerrorismSponsors.contains(pBrand)) {
        return true;
      }
    }

    return false;
  }

  bool _isSponsoredByAnyTerrorismSponsor(ProductInfo product) {
    return any(
      (TerrorismSponsor terrorismSponsor) {
        return _isSponsoredByTerrorismSponsor(terrorismSponsor, product);
      },
    );
  }

  bool _isSponsoredByTerrorismSponsor(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    final String status = terrorismSponsor.status;
    return (status != 'Withdrawal' && status != 'Suspension') &&
        (_isSponsorNameNotEmptyAndMatchesProductBrandOrName(
              terrorismSponsor,
              product,
            ) ||
            _isSponsorBrandsNotEmptyAndContainsProductBrand(
              terrorismSponsor,
              product,
            ) ||
            _isSponsorBrandsNotEmptyAndContainsProductName(
              terrorismSponsor,
              product,
            ));
  }

  bool _isSponsorNameNotEmptyAndMatchesProductBrandOrName(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    final String normalizedSponsorName =
        terrorismSponsor.name.toLowerCase().trim();
    final String normalizedProductBrand = product.brand.toLowerCase().trim();
    final String normalizedProductName = product.name.toLowerCase().trim();

    if (normalizedSponsorName.isEmpty) {
      return false;
    }

    // Split the product's brand string by comma, trim whitespace, and remove
    // empty strings.
    final List<String> productBrands = normalizedProductBrand
        .split(',')
        .map((String brand) => brand.trim())
        .where((String brand) => brand.isNotEmpty)
        .toList();

    // Check if the sponsor name is present in any of the individual product
    // brands.
    if (productBrands.any((String brand) => brand == normalizedSponsorName)) {
      return true;
    }

    // Check if the sponsor name matches the product name.
    return normalizedProductName == normalizedSponsorName;
  }

  bool _isSponsorBrandsNotEmptyAndContainsProductBrand(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    return terrorismSponsor.brands.isNotEmpty &&
        product.brand.isNotEmpty &&
        _doesSponsorBrandsContainProductBrand(terrorismSponsor, product);
  }

  bool _doesSponsorBrandsContainProductBrand(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    // Already lowercase.
    final List<String> sponsorBrandList = _getLowerCaseBrands(terrorismSponsor);
    final String productBrandString = product.brand.toLowerCase().trim();

    if (sponsorBrandList.isEmpty || productBrandString.isEmpty) {
      return false;
    }

    // Split the product's brand string by comma, trim whitespace, and remove
    // empty strings.
    final List<String> productIndividualBrands = productBrandString
        .split(',')
        .map((String brand) => brand.trim())
        .where((String brand) => brand.isNotEmpty)
        .toList();

    // Check if any of the product's individual brands are present in the
    // sponsor's brand list.
    for (final String pBrand in productIndividualBrands) {
      if (sponsorBrandList.contains(pBrand)) {
        return true;
      }
    }
    return false;
  }

  List<String> _getLowerCaseBrands(TerrorismSponsor terrorismSponsor) =>
      terrorismSponsor.brands
          .split(', ')
          .map((String brand) => brand.toLowerCase())
          .toList();

  bool _isSponsorBrandsNotEmptyAndContainsProductName(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    return terrorismSponsor.brands.isNotEmpty &&
        product.name.isNotEmpty &&
        _doesSponsorBrandsContainProductName(terrorismSponsor, product);
  }

  bool _doesSponsorBrandsContainProductName(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    final List<String> sponsorBrandList = _getLowerCaseBrands(terrorismSponsor);
    final String productNameString = product.name.toLowerCase().trim();

    if (sponsorBrandList.isEmpty || productNameString.isEmpty) {
      return false;
    }

    // Check if any of the product's name is present in the
    // sponsor's brand list.
    if (sponsorBrandList.contains(productNameString)) {
      return true;
    }

    return false;
  }
}
