import 'package:entities/entities.dart';

abstract class ProductInfoGateway {
  Future<ProductInfo> getProductInfoAsFuture(String barcode);
}
