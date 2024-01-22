abstract interface class SettingsGateway {
  const SettingsGateway();
  Future<bool> savePrecipitationStateAsFuture(bool isPrecipitationFalling);
  bool getPrecipitationState();
}
