import 'package:entities/entities.dart';

abstract class ProductInfoGateway {
  const ProductInfoGateway();
  Future<ProductInfo> getProductInfoAsFuture(String barcode);
}
