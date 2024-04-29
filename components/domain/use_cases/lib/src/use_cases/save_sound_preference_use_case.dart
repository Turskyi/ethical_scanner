import 'package:use_cases/use_cases.dart';

class SaveSoundPreferenceUseCase implements UseCase<Future<bool>, bool> {
  const SaveSoundPreferenceUseCase(this._settingsGateway);

  final SettingsGateway _settingsGateway;

  @override
  Future<bool> call([bool isSoundOn = false]) =>
      _settingsGateway.saveSoundPreferenceAsFuture(isSoundOn);
}
