enum ProductResponseType {
  openFoodFacts,
  barcodeOnly,
  websiteOnly,
  amazonAsinFallback,
  error,
  nonFoodProduct;

  bool get isSupportedByOpenFoodFacts {
    return this == openFoodFacts || this == barcodeOnly;
  }

  bool get isNotSupportedByOpenFoodFacts => !isSupportedByOpenFoodFacts;

  bool get isBarcodeOnly => this == barcodeOnly;

  bool get isNonFoodProduct => this == nonFoodProduct;
}
