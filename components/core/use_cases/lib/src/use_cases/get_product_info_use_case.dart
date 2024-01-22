import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class GetProductInfoUseCase implements UseCase<Future<ProductInfo>, String> {
  const GetProductInfoUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<ProductInfo> call([String barcode = '']) =>
      _productInfoGateway.getProductInfoAsFuture(barcode);
}
