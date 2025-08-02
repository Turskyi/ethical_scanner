import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class GetProductInfoUseCase
    implements UseCase<Future<ProductInfo>, LocalizedCode> {
  const GetProductInfoUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<ProductInfo> call([
    LocalizedCode barcode = const LocalizedCode(code: ''),
  ]) {
    return _productInfoGateway.getProductInfoAsFuture(barcode);
  }
}
