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

  String? getLeaveRussiaCache(String barcode);

  /// Caches the Leave Russia lookup result for the specified [barcode].
  ///
  /// - [jsonString]: The JSON string to store. This is typically obtained by
  ///   calling `jsonEncode(response.toJson())` on a successful
  ///   [LeaveRussiaResponse] from the Leave Russia API, or the sentinel string
  ///   `'NOT_FOUND'` to record a confirmed cache miss (no company found).
  /// - How to use: Call this method with the barcode and the serialized JSON
  ///   string (or `'NOT_FOUND'`) after querying the Leave Russia API to persist
  ///   the result locally in SharedPreferences and avoid redundant network
  ///   requests.
  Future<bool> saveLeaveRussiaCache({
    required String barcode,
    required String jsonString,
  });
}
