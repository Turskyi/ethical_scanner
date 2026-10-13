import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class AddVegetarianLabelUseCase implements UseCase<Future<void>, String> {
  const AddVegetarianLabelUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([String barcode = '']) {
    return _productInfoGateway.addVegetarianLabel(barcode: barcode);
  }
}
