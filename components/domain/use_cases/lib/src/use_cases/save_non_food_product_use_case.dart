import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class SaveNonFoodProductUseCase implements UseCase<Future<void>, String> {
  const SaveNonFoodProductUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([String barcode = '']) {
    return _productInfoGateway.saveNonFoodProduct(barcode: barcode);
  }
}
