import 'package:entities/entities.dart';
import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class CheckVegetarianParams {
  const CheckVegetarianParams({
    required this.ingredients,
    required this.barcode,
  });

  final String ingredients;
  final String barcode;
}

class CheckVegetarianUseCase
    implements
        UseCase<Future<AiVegetarianCheckResponse>, CheckVegetarianParams> {
  const CheckVegetarianUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<AiVegetarianCheckResponse> call([
    CheckVegetarianParams params = const CheckVegetarianParams(
      ingredients: '',
      barcode: '',
    ),
  ]) {
    return _productInfoGateway.checkVegetarianWithAi(
      ingredients: params.ingredients,
      barcode: params.barcode,
    );
  }
}
