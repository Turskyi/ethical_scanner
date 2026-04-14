import 'package:entities/entities.dart';
import 'package:use_cases/src/gateways/product_info_gateway.dart';
import 'package:use_cases/src/use_cases/use_case.dart';

class SaveIngredientsParams {
  const SaveIngredientsParams({
    required this.barcode,
    required this.ingredientsText,
    required this.language,
  });

  final String barcode;
  final String ingredientsText;
  final Language language;
}

class SaveIngredientsUseCase
    implements UseCase<Future<void>, SaveIngredientsParams> {
  const SaveIngredientsUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<void> call([
    SaveIngredientsParams params = const SaveIngredientsParams(
      barcode: '',
      ingredientsText: '',
      language: Language.en,
    ),
  ]) {
    return _productInfoGateway.saveIngredients(
      barcode: params.barcode,
      ingredientsText: params.ingredientsText,
      language: params.language,
    );
  }
}
