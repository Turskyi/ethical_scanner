class AiBarcodeInfoRequest {
  const AiBarcodeInfoRequest({required this.barcode, this.language});

  factory AiBarcodeInfoRequest.fromJson(Map<String, Object?> json) {
    final Object? barcode = json['barcode'];
    final Object? language = json['language'];
    if (barcode is String) {
      return AiBarcodeInfoRequest(
        barcode: barcode,
        language: language is String ? language : null,
      );
    } else {
      throw const FormatException('Invalid AI barcode info request.');
    }
  }

  final String barcode;
  final String? language;

  Map<String, Object?> toJson() => <String, Object?>{
    'barcode': barcode,
    if (language != null && language!.isNotEmpty) 'language': language,
  };
}
