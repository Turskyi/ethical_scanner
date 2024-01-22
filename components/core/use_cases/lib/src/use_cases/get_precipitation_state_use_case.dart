import 'package:use_cases/use_cases.dart';

class SavePrecipitationStateUseCase implements UseCase<Future<bool>, bool> {
  const SavePrecipitationStateUseCase(this._settingsGateway);

  final SettingsGateway _settingsGateway;

  @override
  Future<bool> call(bool isPrecipitationFalling) =>
      _settingsGateway.savePrecipitationStateAsFuture(isPrecipitationFalling);
}
