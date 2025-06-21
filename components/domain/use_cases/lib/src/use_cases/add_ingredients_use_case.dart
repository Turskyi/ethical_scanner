import 'package:entities/entities.dart';
import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class AddIngredientsUseCase implements UseCase<Future<void>, ProductPhoto> {
  const AddIngredientsUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([ProductPhoto productPhoto = const ProductPhoto()]) async {
    if (productPhoto.info.name.isEmpty) {
      try {
        // First, attempt to add the product info.
        await _productInfoGateway.addProduct(productPhoto.info);

        // If addProduct was successful, then attempt to add ingredients
        // This will only run if addProduct did not throw an error.
        await _productInfoGateway.addIngredients(productPhoto);
      } catch (e) {
        // If either addProduct or addIngredients throws an error,
        // it will be caught here. We then rethrow it so the caller
        // of the use case can handle it.
        print('Error in AddIngredientsUseCase: $e');
        // This is crucial to propagate the error.
        rethrow;
      }
    } else {
      // If name is not empty, just add ingredients directly.
      try {
        await _productInfoGateway.addIngredients(productPhoto);
      } catch (e) {
        print(
          'Error in AddIngredientsUseCase (only when trying to do only '
          'addIngredients): $e',
        );
        rethrow;
      }
    }
  }
}
