import 'package:entities/entities.dart';

abstract interface class ProductInfoGateway {
  const ProductInfoGateway();

  Future<ProductInfo> getProductInfoAsFuture(Barcode barcode);

  Future<void> addProduct(ProductInfo productInfo);

  Future<void> addIngredients(ProductPhoto productPhoto);
}
