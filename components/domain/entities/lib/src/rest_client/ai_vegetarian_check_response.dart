class AiVegetarianCheckResponse {
  const AiVegetarianCheckResponse({
    required this.isVegetarian,
    required this.confidence,
    required this.reason,
    required this.provider,
    required this.model,
  });

  factory AiVegetarianCheckResponse.fromJson(Map<String, Object?> json) {
    final Object? isVegetarian = json['isVegetarian'];
    final Object? confidence = json['confidence'];
    final Object? reason = json['reason'];
    final Object? provider = json['provider'];
    final Object? model = json['model'];

    if (isVegetarian is bool &&
        reason is String &&
        (provider == null || provider is String) &&
        (confidence == null || confidence is String) &&
        (model == null || model is String)) {
      return AiVegetarianCheckResponse(
        isVegetarian: isVegetarian,
        confidence: confidence is String ? confidence : 'medium',
        reason: reason,
        provider: provider is String ? provider : '',
        model: model is String ? model : '',
      );
    } else {
      throw const FormatException('Invalid AI vegetarian check response.');
    }
  }

  final bool isVegetarian;
  final String confidence;
  final String reason;
  final String provider;
  final String model;
}
