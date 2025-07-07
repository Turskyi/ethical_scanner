enum ProductResponseType {
  openFoodFacts,
  barcodeOnly,
  websiteOnly,
  amazonAsinFallback,
  error;

  bool get isSupportedByOpenFoodFacts =>
      this == openFoodFacts || this == barcodeOnly;

  bool get isNotSupportedByOpenFoodFacts => !isSupportedByOpenFoodFacts;
}
