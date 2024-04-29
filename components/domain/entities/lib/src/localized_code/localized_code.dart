import 'package:entities/src/enums/language.dart';

class LocalizedCode {
  const LocalizedCode({
    required this.code,
    this.language = Language.en,
  });

  final String code;
  final Language language;
}
