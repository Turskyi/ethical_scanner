import 'package:entities/src/enums/language.dart';

class LeaveRussiaCompanyPage {
  const LeaveRussiaCompanyPage({this.en = '', this.uk = ''});

  factory LeaveRussiaCompanyPage.fromJson(Object? json) {
    final Map<String, Object?> map = json is Map<String, Object?>
        ? json
        : const <String, Object?>{};
    return LeaveRussiaCompanyPage(
      en: map[_enJsonKey] as String? ?? '',
      uk: map[_ukJsonKey] as String? ?? '',
    );
  }

  final String en;
  final String uk;

  static const String _enJsonKey = 'en';
  static const String _ukJsonKey = 'uk';

  String getUrlForLanguage(Language language) {
    final String raw = (language.isUkrainian && uk.isNotEmpty)
        ? uk
        : en.isNotEmpty
        ? en
        : uk;
    if (raw.isEmpty) {
      return '';
    }
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    if (raw.startsWith('/')) {
      return 'https://leave-russia.org$raw';
    }
    return 'https://leave-russia.org/$raw';
  }

  Map<String, Object?> toJson() => <String, Object?>{
    _enJsonKey: en,
    _ukJsonKey: uk,
  };
}
