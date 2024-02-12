import 'dart:async';

import 'package:interface_adapters/src/data_sources/local/local_data_source.dart';
import 'package:use_cases/use_cases.dart';

class SettingsGatewayImpl implements SettingsGateway {
  const SettingsGatewayImpl(this._localDataSource);

  final LocalDataSource _localDataSource;

  @override
  Future<bool> savePrecipitationStateAsFuture(bool isPrecipitationFalling) =>
      _localDataSource.savePrecipitationState(isPrecipitationFalling);

  @override
  bool getPrecipitationState() => _localDataSource.getPrecipitationState();

  @override
  String getLanguageIsoCode() => _localDataSource.getLanguageIsoCode();

  @override
  Future<bool> saveLanguageIsoCodeAsFuture(String languageIsoCode) =>
      _localDataSource.saveLanguageIsoCode(languageIsoCode);

  @override
  bool getSoundPreference() => _localDataSource.getSoundPreference();

  @override
  Future<bool> saveSoundPreferenceAsFuture(bool isSoundOn) =>
      _localDataSource.saveSoundPreference(isSoundOn);
}
