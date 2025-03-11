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
  bool sponsoredBy(ProductInfo product) =>
      _isSponsoredByOtherRussiaSponsors(product) ||
      _isSponsoredByAnyTerrorismSponsor(product);

  bool _isSponsoredByOtherRussiaSponsors(ProductInfo product) =>
      _otherTerrorismSponsors.contains(product.brand.toLowerCase());

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
        'twix',
        'quaker',
        'nestlé',
        'pepsi cola',
        'bacardi, martini',
        'quakerquaker oats',
      ];
}
