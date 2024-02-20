import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class GetLanguageUseCase implements UseCase<Language, Null> {
  const GetLanguageUseCase(this._settingsGateway);

  final SettingsGateway _settingsGateway;

  @override
  Language call([_]) =>
      Language.fromIsoLanguageCode(_settingsGateway.getLanguageIsoCode());
}
