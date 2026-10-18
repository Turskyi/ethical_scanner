class AiVegetarianCheckRequest {
  const AiVegetarianCheckRequest({
    required this.ingredients,
    this.barcode,
    this.language,
  });

  factory AiVegetarianCheckRequest.fromJson(Map<String, Object?> json) {
    final Object? ingredients = json['ingredients'];
    final Object? barcode = json['barcode'];
    final Object? language = json['language'];
    if (ingredients is String) {
      return AiVegetarianCheckRequest(
        ingredients: ingredients,
        barcode: barcode is String ? barcode : null,
        language: language is String ? language : null,
      );
    } else {
      throw const FormatException('Invalid AI vegetarian check request.');
    }
  }

  final String ingredients;
  final String? barcode;
  final String? language;

  Map<String, Object?> toJson() => <String, Object?>{
    'ingredients': ingredients,
    if (barcode != null && barcode!.isNotEmpty) 'barcode': barcode,
    if (language != null && language!.isNotEmpty) 'language': language,
  };
}
