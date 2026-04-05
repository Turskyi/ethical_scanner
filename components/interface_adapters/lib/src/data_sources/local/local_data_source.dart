abstract interface class LocalDataSource {
  const LocalDataSource();

  Future<void> init();

  String getGs1CountryFromBarcode(String barcode);

  String getReportedOriginFromBarcode(String barcode);

  bool isEnglishBook(String barcode);

  Future<bool> savePrecipitationState(bool isPrecipitationFalling);

  bool getPrecipitationState();

  String getLanguageIsoCode();

  Future<bool> saveLanguageIsoCode(String languageIsoCode);

  Future<bool> saveSoundPreference(bool isSoundOn);

  bool getSoundPreference();
}
