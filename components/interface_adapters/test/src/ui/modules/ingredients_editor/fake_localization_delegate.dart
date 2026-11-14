import 'package:entities/entities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mockito/mockito.dart';

class FakeLocalizationDelegate extends Mock implements LocalizationDelegate {
  Locale _currentLocale = Locale(Language.en.isoLanguageCode);

  @override
  Locale get currentLocale => _currentLocale;

  @override
  Type get type => Localization;

  @override
  bool isSupported(Locale? locale) => true;

  @override
  List<Locale> get supportedLocales => <Locale>[
    Locale(Language.en.isoLanguageCode),
    Locale(Language.uk.isoLanguageCode),
  ];

  @override
  Future<Localization> load(Locale locale) async => Localization.instance;

  @override
  Future<void> changeLocale(Locale newLocale) async {
    _currentLocale = newLocale;
  }
}
