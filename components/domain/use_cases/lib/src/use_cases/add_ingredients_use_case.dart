import 'package:entities/entities.dart';
import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class AddIngredientsUseCase implements UseCase<Future<void>, ProductPhoto> {
  const AddIngredientsUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([ProductPhoto productPhoto = const ProductPhoto()]) {
    if (productPhoto.info.name.isEmpty) {
      return _productInfoGateway.addProduct(productPhoto.info).whenComplete(() {
        _productInfoGateway.addIngredients(productPhoto);
      });
    } else {
      return _productInfoGateway.addIngredients(productPhoto);
    }
  }
}
