import 'package:entities/entities.dart';

abstract class RemoteDataSource {
  Future<ProductInfo> getProductInfoAsFuture(String barcode);

  Future<String> getIngredientsText(String barcode);

  Future<String> getCountryFromAiAsFuture(String barcode);
}
