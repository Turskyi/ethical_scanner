import 'package:entities/entities.dart';

abstract interface class RemoteDataSource {
  const RemoteDataSource();

  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode barcode);

  Future<String> getIngredientsText(LocalizedCode barcode);

  Future<String> getInfoFromAiAsFuture(String barcode);

  Future<void> addProduct(ProductInfo productInfo);

  Future<void> addIngredients(ProductPhoto productPhoto);
}
