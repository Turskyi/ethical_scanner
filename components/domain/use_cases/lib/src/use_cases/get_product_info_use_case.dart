import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class GetProductInfoUseCase
    implements UseCase<Future<ProductInfo>, LocalizedCode> {
  const GetProductInfoUseCase(this._productInfoGateway);

  final ProductInfoGateway _productInfoGateway;

  @override
  Future<ProductInfo> call([
    LocalizedCode barcode = const LocalizedCode(code: ''),
  ]) async {
    final String code = barcode.code;
    final Language language = barcode.language;

    // Step 1: Barcode starts with 46: keep the existing Russian-product
    // result. Do not call Leave Russia.
    if (code.startsWith(ProductInfo.russianBarcodePrefix)) {
      return _getStandardProductInfo(barcode);
    } else {
      // If the code starts with 0, drop that first digit, then send the rest.
      final String searchCode = code.startsWith('0') ? code.substring(1) : code;

      // Step 2: Call the barcode endpoint, using the cache.
      LeaveRussiaResponse? leaveRussiaResponse;
      try {
        leaveRussiaResponse = await _productInfoGateway.getLeaveRussiaInfo(
          barcode: searchCode,
          language: language,
        );
      } catch (_) {
        leaveRussiaResponse = null;
      }

      final LeaveRussiaItem? leaveRussiaCompanyRecord =
          leaveRussiaResponse?.firstItem;

      // Step 5: On timeout, error, or "Nothing was found": run current Open
      // Food Facts plus Yale-list path unchanged.
      if (leaveRussiaCompanyRecord == null) {
        return _getStandardProductInfo(barcode);
      } else {
        final String companyUrl =
            leaveRussiaCompanyRecord.companyPage?.getUrlForLanguage(language) ??
            '';
        final String companyBrand = leaveRussiaCompanyRecord.displayName;

        // Step 3: If status.key is stay:
        if (leaveRussiaCompanyRecord.status?.isStay == true) {
          // Set the company as an active sponsor using the existing flag.
          // Use their name as the brand. Do not look that name up again in the
          // Yale JSON.
          final ProductInfo offProduct = await _fetchOffProductInfoSafely(
            barcode,
          );
          final String finalBrand = offProduct.brand.isNotEmpty
              ? offProduct.brand
              : companyBrand;

          return offProduct.copyWith(
            brand: finalBrand,
            isCompanyTerrorismSponsor: leaveRussiaCompanyRecord.status?.isStay,
            leaveRussiaUrl: companyUrl,
          );
        } else {
          // Step 4: If status.key is leave or exited:
          if (leaveRussiaCompanyRecord.status?.isLeavingOrExited == true) {
            // Do not set the sponsor flag. Still keep their company-page URL.
            // Then run Open Food Facts as today, so vegetarian or vegan can
            // make the product green.
            final ProductInfo offProduct = await _fetchOffProductInfoSafely(
              barcode,
            );

            final String finalBrand = offProduct.brand.isNotEmpty
                ? offProduct.brand
                : companyBrand;

            return offProduct.copyWith(
              brand: finalBrand,
              isCompanyTerrorismSponsor:
                  leaveRussiaCompanyRecord.status?.isStay,
              leaveRussiaUrl: companyUrl,
            );
          }
        }
      }
    }

    // Default fallback if statusKey is unknown
    return _getStandardProductInfo(barcode);
  }

  Future<ProductInfo> _fetchOffProductInfoSafely(LocalizedCode barcode) async {
    try {
      return await _productInfoGateway.getProductInfoAsFuture(barcode);
    } catch (_) {
      return ProductInfo(barcode: barcode.code, language: barcode.language);
    }
  }

  Future<ProductInfo> _getStandardProductInfo(LocalizedCode barcode) async {
    final ProductInfo product = await _productInfoGateway
        .getProductInfoAsFuture(barcode);
    if (product.brand.isNotEmpty || product.name.isNotEmpty) {
      try {
        final List<TerrorismSponsor> terrorismSponsors =
            await _productInfoGateway.getTerrorismSponsors();
        return product.copyWith(
          isCompanyTerrorismSponsor: terrorismSponsors.sponsoredBy(product),
        );
      } catch (_) {
        return product;
      }
    } else {
      return product;
    }
  }
}
