part of 'home_presenter.dart';

abstract class HomeViewModel {
  const HomeViewModel({
    this.isPrecipitationFalls = true,
    this.language = Language.en,
  });

  final Language language;
  final bool isPrecipitationFalls;
}

abstract class ProductInfoState extends HomeViewModel {
  const ProductInfoState({
    this.productInfoMap = const <ProductInfoType, String>{},
    this.productInfo = const ProductInfo(),
    super.language,
    super.isPrecipitationFalls,
  });

  final Map<ProductInfoType, String> productInfoMap;
  final ProductInfo productInfo;
}

class LoadingHomeState extends HomeViewModel {
  const LoadingHomeState();
}

class ReadyToScanState extends HomeViewModel {
  const ReadyToScanState({
    super.language,
    super.isPrecipitationFalls,
  });

  ReadyToScanState copyWith({
    Language? language,
    bool? isPrecipitationFalls,
  }) =>
      ReadyToScanState(
        language: language ?? this.language,
        isPrecipitationFalls: isPrecipitationFalls ?? this.isPrecipitationFalls,
      );
}

class ScanState extends HomeViewModel {
  const ScanState({super.language, super.isPrecipitationFalls});
}

class LoadingProductInfoState extends ProductInfoState {
  const LoadingProductInfoState({
    super.productInfoMap,
    super.language,
    super.isPrecipitationFalls,
  });

  LoadingProductInfoState copyWith({
    Map<ProductInfoType, String>? productInfoMap,
    Language? language,
    bool? isPrecipitationFalls,
  }) =>
      LoadingProductInfoState(
        productInfoMap: productInfoMap ?? this.productInfoMap,
        language: language ?? this.language,
        isPrecipitationFalls: isPrecipitationFalls ?? this.isPrecipitationFalls,
      );
}

class LoadedProductInfoState extends ProductInfoState {
  const LoadedProductInfoState({
    super.productInfoMap,
    super.productInfo,
    super.language,
    super.isPrecipitationFalls,
  });
}

class HomeErrorState extends HomeViewModel {
  const HomeErrorState(this.errorMessage);

  final String errorMessage;
}

class PhotoMakerState extends ProductInfoState {
  const PhotoMakerState({
    required super.productInfo,
    super.language,
    super.isPrecipitationFalls,
  });
}
