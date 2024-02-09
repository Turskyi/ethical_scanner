abstract interface class SettingsGateway {
  const SettingsGateway();

  Future<bool> savePrecipitationStateAsFuture(bool isPrecipitationFalling);

  bool getPrecipitationState();

  Future<bool> saveLanguageIsoCodeAsFuture(String languageIsoCode);

  String getLanguageIsoCode();
}
