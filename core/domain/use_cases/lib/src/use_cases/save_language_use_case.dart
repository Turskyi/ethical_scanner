import 'package:entities/entities.dart' as language;
import 'package:use_cases/use_cases.dart';

class SaveLanguageUseCase implements UseCase<Future<bool>, String> {
  const SaveLanguageUseCase(this._settingsGateway);

  final SettingsGateway _settingsGateway;

  @override
  Future<bool> call([
    String languageIsoCode = language.englishIsoLanguageCode,
  ]) =>
      _settingsGateway.saveLanguageIsoCodeAsFuture(languageIsoCode);
}
