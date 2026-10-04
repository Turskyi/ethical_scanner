class AiBarcodeInfoResponse {
  const AiBarcodeInfoResponse({
    required this.info,
    required this.provider,
    required this.model,
  });

  factory AiBarcodeInfoResponse.fromJson(Map<String, Object?> json) {
    final Object? info = json['info'];
    final Object? provider = json['provider'];
    final Object? model = json['model'];
    if (info is String &&
        provider is String &&
        (model == null || model is String)) {
      return AiBarcodeInfoResponse(
        info: info,
        provider: provider,
        model: model is String ? model : '',
      );
    } else {
      throw const FormatException('Invalid AI barcode information response.');
    }
  }

  final String info;
  final String provider;
  final String model;
}
