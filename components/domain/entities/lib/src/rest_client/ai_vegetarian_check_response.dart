class AiVegetarianCheckResponse {
  const AiVegetarianCheckResponse({
    required this.isVegetarian,
    required this.confidence,
    required this.reason,
    required this.provider,
    required this.model,
  });

  factory AiVegetarianCheckResponse.fromJson(Map<String, Object?> json) {
    final Object? isVegetarian = json[_isVegetarianJsonKey];
    final Object? confidence = json[_confidenceJsonKey];
    final Object? reason = json[_reasonJsonKey];
    final Object? provider = json[_providerJsonKey];
    final Object? model = json[_modelJsonKey];

    if (isVegetarian is bool &&
        reason is String &&
        (provider == null || provider is String) &&
        (confidence == null || confidence is String) &&
        (model == null || model is String)) {
      return AiVegetarianCheckResponse(
        isVegetarian: isVegetarian,
        confidence: confidence is String ? confidence : _defaultConfidence,
        reason: reason,
        provider: provider is String ? provider : '',
        model: model is String ? model : '',
      );
    } else {
      throw const FormatException('Invalid AI vegetarian check response.');
    }
  }

  static const String _isVegetarianJsonKey = 'isVegetarian';
  static const String _confidenceJsonKey = 'confidence';
  static const String _reasonJsonKey = 'reason';
  static const String _providerJsonKey = 'provider';
  static const String _modelJsonKey = 'model';
  static const String _defaultConfidence = 'medium';

  final bool isVegetarian;
  final String confidence;
  final String reason;
  final String provider;
  final String model;
}
