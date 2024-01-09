enum ProductInfoKey {
  code,
  productName,
  countryOfOrigin,
  countryWhereSold,
  brand,
  isVegan,
  isVegetarian,
  packaging,
  ingredients,
  website,
  countryAi,
  error,
}

extension ProductInfoKeyExtension on ProductInfoKey {
  String get value {
    switch (this) {
      case ProductInfoKey.code:
        return 'Code: ';
      case ProductInfoKey.productName:
        return 'Product name: ';
      case ProductInfoKey.countryOfOrigin:
        return 'Country of origin: ';
      case ProductInfoKey.countryWhereSold:
        return 'Country where the product is sold: ';
      case ProductInfoKey.brand:
        return 'Brand: ';
      case ProductInfoKey.isVegan:
        return 'Is vegan? ';
      case ProductInfoKey.isVegetarian:
        return 'Is vegetarian? ';
      case ProductInfoKey.packaging:
        return 'Packaging: ';
      case ProductInfoKey.ingredients:
        return 'Ingredients: ';
      case ProductInfoKey.website:
        return 'Website: ';
      case ProductInfoKey.countryAi:
        return 'AI-Generated Country Information: ';
      case ProductInfoKey.error:
        return 'Error: ';
    }
  }

  bool get isWebsite => this == ProductInfoKey.website;
}
