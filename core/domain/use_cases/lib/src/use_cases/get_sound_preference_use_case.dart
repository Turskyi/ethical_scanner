import 'package:use_cases/use_cases.dart';

class GetSoundPreferenceUseCase implements UseCase<bool, Null> {
  const GetSoundPreferenceUseCase(this._settingsGateway);

  final SettingsGateway _settingsGateway;

  @override
  bool call([_]) => _settingsGateway.getSoundPreference();
}
