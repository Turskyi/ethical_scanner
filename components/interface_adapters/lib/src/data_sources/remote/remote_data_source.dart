import 'package:entities/entities.dart';

abstract interface class RemoteDataSource {
  const RemoteDataSource();

  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode barcode);

  Future<List<TerrorismSponsor>> getTerrorismSponsors();

  Future<String> getIngredientsText(LocalizedCode barcode);

  Future<String> getInfoFromAiAsFuture(String barcode);

  Future<void> addProduct(ProductInfo productInfo);

  Future<void> addIngredients(ProductPhoto productPhoto);

  Future<String> extractIngredients(ProductPhoto productPhoto);

  Future<void> saveIngredients({
    required String barcode,
    required String ingredientsText,
    required Language language,
  });
}
