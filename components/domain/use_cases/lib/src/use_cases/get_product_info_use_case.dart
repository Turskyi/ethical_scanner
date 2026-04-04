import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class GetProductInfoUseCase
    implements UseCase<Future<ProductInfo>, LocalizedCode> {
  const GetProductInfoUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<ProductInfo> call([
    LocalizedCode barcode = const LocalizedCode(code: ''),
  ]) {
    return _productInfoGateway.getProductInfoAsFuture(barcode).then((
      ProductInfo product,
    ) {
      if (product.brand.isNotEmpty || product.name.isNotEmpty) {
        return _productInfoGateway
            .getTerrorismSponsors()
            .then((List<TerrorismSponsor> terrorismSponsors) {
              return product.copyWith(
                isCompanyTerrorismSponsor: terrorismSponsors.sponsoredBy(
                  product,
                ),
              );
            })
            .onError((Object? error, StackTrace _) => product);
      } else {
        return product;
      }
    });
  }
}
