import 'package:entities/entities.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

extension LanguageDataMapper on Language {
  OpenFoodFactsLanguage get toOpenFoodFactsLanguage {
    if (isoLanguageCode == OpenFoodFactsLanguage.ENGLISH.code) {
      return OpenFoodFactsLanguage.ENGLISH;
    } else if (isoLanguageCode == OpenFoodFactsLanguage.UKRAINIAN.code) {
      return OpenFoodFactsLanguage.UKRAINIAN;
    } else {
      return OpenFoodFactsLanguage.ENGLISH;
    }
  }
}
