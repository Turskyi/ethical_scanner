import 'package:use_cases/use_cases.dart';

class GetPrecipitationStateUseCase implements UseCase<bool, Null> {
  const GetPrecipitationStateUseCase(this._settingsGateway);

  final SettingsGateway _settingsGateway;

  @override
  bool call([_]) =>
      _settingsGateway.getPrecipitationState();
}
