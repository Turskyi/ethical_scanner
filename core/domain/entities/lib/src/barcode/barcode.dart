import 'package:entities/src/enums/language.dart';

class Barcode {
  const Barcode({
    required this.code,
    this.language = Language.en,
  });

  final String code;
  final Language language;
}
