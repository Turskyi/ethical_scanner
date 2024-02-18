import 'package:entities/entities.dart';
import 'package:ethical_scanner/res/values/constants.dart' as constants;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';

Future<LocalizationDelegate> getLocalizationDelegate() async {
  // Get the singleton instance of the `PlatformDispatcher`.
  PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;

  // Get the current locale from the `PlatformDispatcher`.
  Locale deviceLocale = platformDispatcher.locale;

  // Get the language code from the `Locale`.
  String deviceIsoLanguageCode = deviceLocale.languageCode;

  LocalizationDelegate localizationDelegate = await LocalizationDelegate.create(
    fallbackLocale: Language.fromIsoLanguageCode(
      deviceIsoLanguageCode,
    ).isoLanguageCode,
    supportedLocales: Language.values
        .map((Language language) => language.isoLanguageCode)
        .toList(),
    basePath: constants.localePath,
  );
  return localizationDelegate;
}
