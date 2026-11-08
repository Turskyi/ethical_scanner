import 'package:entities/entities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mockito/mockito.dart';

class FakeLocalizationDelegate extends Mock implements LocalizationDelegate {
  Locale _currentLocale = Locale(Language.en.isoLanguageCode);

  @override
  Locale get currentLocale => _currentLocale;

  @override
  Future<void> changeLocale(Locale newLocale) async {
    _currentLocale = newLocale;
  }
}
