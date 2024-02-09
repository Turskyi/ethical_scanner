import 'package:entities/entities.dart';

abstract interface class RemoteDataSource {
  const RemoteDataSource();
  Future<ProductInfo> getProductInfoAsFuture(Barcode barcode);

  Future<String> getIngredientsText(Barcode barcode);

  Future<String> getCountryFromAiAsFuture(String barcode);

  Future<void> addProduct(ProductInfo productInfo);

  Future<void> addIngredients(ProductPhoto productPhoto);
}
