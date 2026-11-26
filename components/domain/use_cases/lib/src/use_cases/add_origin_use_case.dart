import 'package:entities/entities.dart';
import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class AddOriginUseCase implements UseCase<Future<void>, AddOriginParams> {
  const AddOriginUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([AddOriginParams? params]) {
    if (params == null) {
      throw ArgumentError('AddOriginParams cannot be null');
    } else {
      return _productInfoGateway.addOrigin(
        barcode: params.barcode,
        origin: params.origin,
        photoPath: params.photoPath,
      );
    }
  }
}
