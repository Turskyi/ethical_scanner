import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class UpdateProductDetailsParams {
  const UpdateProductDetailsParams({
    required this.barcode,
    required this.productName,
    required this.canHaveIngredients,
  });

  final String barcode;
  final String productName;
  final bool canHaveIngredients;
}

class UpdateProductDetailsUseCase
    implements UseCase<Future<void>, UpdateProductDetailsParams> {
  const UpdateProductDetailsUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([UpdateProductDetailsParams? params]) {
    if (params == null) {
      throw ArgumentError('UpdateProductDetailsParams cannot be null');
    }
    return _productInfoGateway.updateProductDetails(
      barcode: params.barcode,
      productName: params.productName,
      canHaveIngredients: params.canHaveIngredients,
    );
  }
}
