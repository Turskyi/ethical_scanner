abstract interface class LocalDataSource {
  const LocalDataSource();

  Future<void> init();

  String getCountryFromBarcode(String barcode);

  bool isEnglishBook(String barcode);

  Future<bool> savePrecipitationState(bool isPrecipitationFalling);

  bool getPrecipitationState();
}
