import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class GetProductInfoUseCase implements UseCase<Future<ProductInfo>, Barcode> {
  const GetProductInfoUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<ProductInfo> call([Barcode barcode = const Barcode(code: '')]) =>
      _productInfoGateway.getProductInfoAsFuture(barcode);
}
