/// [IsoCode] is an enum object that contains all supported ISO 639-1 code
/// languages by project.
enum IsoCode {
  en,
  ua;

  bool get isEnglish => this == IsoCode.en;

  static IsoCode fromLanguageCode(String langCode) {
    switch (langCode.trim().toLowerCase()) {
      case _englishIsoCode:
        return IsoCode.en;
      case _ukrainianIsoCode:
        return IsoCode.ua;
      default:
        return IsoCode.en;
    }
  }
}

const String _englishIsoCode = 'en';
const String _ukrainianIsoCode = 'ua';
