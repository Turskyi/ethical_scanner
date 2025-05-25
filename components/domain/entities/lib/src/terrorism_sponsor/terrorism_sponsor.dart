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

  bool _isSponsoredByOtherRussiaSponsors(ProductInfo product) {
    final String brand = product.brand.toLowerCase();

    return _otherTerrorismSponsors.contains(brand);
  }

  bool _isSponsoredByAnyTerrorismSponsor(ProductInfo product) {
    return any(
      (TerrorismSponsor terrorismSponsor) =>
          _isSponsoredByTerrorismSponsor(terrorismSponsor, product),
    );
  }

  bool _isSponsoredByTerrorismSponsor(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) =>
      terrorismSponsor.status != 'Withdrawal' &&
      (_isSponsorNameNotEmptyAndMatchesProductBrandOrName(
            terrorismSponsor,
            product,
          ) ||
          _isSponsorBrandsNotEmptyAndContainsProductBrand(
            terrorismSponsor,
            product,
          ));

  bool _isSponsorNameNotEmptyAndMatchesProductBrandOrName(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) =>
      terrorismSponsor.name.isNotEmpty &&
      (product.brand.toLowerCase().trim() ==
              terrorismSponsor.name.toLowerCase().trim() ||
          product.name.toLowerCase().trim() ==
              terrorismSponsor.name.toLowerCase().trim());

  bool _isSponsorBrandsNotEmptyAndContainsProductBrand(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) =>
      terrorismSponsor.brands.isNotEmpty &&
      product.brand.isNotEmpty &&
      _doesSponsorBrandsContainProductBrand(terrorismSponsor, product);

  bool _doesSponsorBrandsContainProductBrand(
    TerrorismSponsor terrorismSponsor,
    ProductInfo product,
  ) {
    final List<String> lowerCaseBrands = _getLowerCaseBrands(terrorismSponsor);
    return lowerCaseBrands.contains(product.brand.toLowerCase());
  }

  List<String> _getLowerCaseBrands(TerrorismSponsor terrorismSponsor) =>
      terrorismSponsor.brands
          .split(', ')
          .map((String brand) => brand.toLowerCase())
          .toList();

  List<String> get _otherTerrorismSponsors => <String>[
        'quaker',
        'nestlé',
        'pepsi cola',
        'bacardi, martini',
        'quakerquaker oats',
        'bounty chocolate',
        'mars inc.',
      ];
}
