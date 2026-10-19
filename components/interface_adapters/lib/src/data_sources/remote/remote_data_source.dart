import 'package:entities/entities.dart';

abstract interface class RemoteDataSource {
  const RemoteDataSource();

  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode barcode);

  Future<List<TerrorismSponsor>> getTerrorismSponsors();

  /// Queries the Leave Russia / KSE Institute barcode lookup API for company
  /// operational status in Russia for the given [barcode].
  ///
  /// Example hit response:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Ferrero SpA",
  ///       "company_name": "Ferrero",
  ///       "status": {
  ///         "key": "stay",
  ///         "en": "Stay",
  ///         "uk": "Залишається"
  ///       },
  ///       "companypage": {
  ///         "en": "https://leave-russia.org/ferrero",
  ///         "uk": "https://leave-russia.org/uk/ferrero"
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Example miss response:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  /// or `"Nothing was found"`.
  Future<LeaveRussiaResponse?> getLeaveRussiaInfo({required String barcode});

  Future<String> getIngredientsText(LocalizedCode barcode);

  Future<AiBarcodeInfoResponse> getInfoFromAiAsFuture({
    required String barcode,
    required Language language,
  });

  Future<void> addProduct(ProductInfo productInfo);

  Future<void> addIngredients(ProductPhoto productPhoto);

  Future<String> extractIngredients(ProductPhoto productPhoto);

  Future<void> saveIngredients({
    required String barcode,
    required String ingredientsText,
    required Language language,
  });

  /// Checks whether a product with the given [ingredients] and [barcode]
  /// can be confidently identified as 100% vegetarian using backend AI
  /// analysis.
  ///
  /// - [ingredients]: The text string of product ingredients.
  /// - [barcode]: The product barcode.
  /// - [language]: The user's target language.
  ///
  /// Returns an [AiVegetarianCheckResponse].
  Future<AiVegetarianCheckResponse> checkVegetarianWithAi({
    required String ingredients,
    required String barcode,
    required Language language,
  });

  Future<void> addVegetarianLabel({required String barcode});

  Future<void> saveNonFoodProduct({required String barcode});

  Future<void> updateProductDetails({
    required String barcode,
    required String productName,
    required bool canHaveIngredients,
  });
}
