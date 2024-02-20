enum ProductInfoType {
  code('product_info.code_colon'),
  productName('product_info.product_name_colon'),
  originCountry('product_info.origin_country_colon'),
  countryWhereSold('product_info.country_where_sold_colon'),
  brand('product_info.brand_colon'),
  companyTerrorismSponsor('product_info.is_company_terrorism_sponsor'),
  countryTerrorismSponsor('product_info.is_country_terrorism_sponsor'),
  isVegan('product_info.is_vegan'),
  isVegetarian('product_info.is_vegetarian'),
  packaging('product_info.packaging_colon'),
  ingredients('product_info.ingredients_colon'),
  website('product_info.website_colon'),
  countryAi('product_info.country_ai_colon'),
  error('product_info.error_colon');

  const ProductInfoType(this.key);

  final String key;

  bool get isWebsite => this == ProductInfoType.website;

  bool get isCompanyWarSponsor =>
      this == ProductInfoType.companyTerrorismSponsor;

  bool get isTerrorismSponsor =>
      this == ProductInfoType.countryTerrorismSponsor;

  bool get isCode => this == ProductInfoType.code;

  bool get isIngredients => this == ProductInfoType.ingredients;
}
