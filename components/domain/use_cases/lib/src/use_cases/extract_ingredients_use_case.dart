import 'package:entities/entities.dart';
import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class ExtractIngredientsUseCase
    implements UseCase<Future<String>, ProductPhoto> {
  const ExtractIngredientsUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<String> call([ProductPhoto productPhoto = const ProductPhoto()]) {
    return _productInfoGateway.extractIngredients(productPhoto);
  }
}
