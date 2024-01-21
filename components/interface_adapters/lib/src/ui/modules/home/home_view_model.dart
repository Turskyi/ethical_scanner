part of 'home_presenter.dart';

abstract class HomeViewModel {
  const HomeViewModel({this.productInfoMap = const <ProductInfoKey, String>{}});

  final Map<ProductInfoKey, String> productInfoMap;
}

class ReadyToScanState extends HomeViewModel {
  const ReadyToScanState({
    super.productInfoMap,
    this.isPrecipitationFalls = true,
  });

  final bool isPrecipitationFalls;
}

class ScanState extends HomeViewModel {
  const ScanState() : super();
}

class LoadingProductInfoState extends HomeViewModel {
  const LoadingProductInfoState(Map<ProductInfoKey, String> productInfo)
      : super(productInfoMap: productInfo);
}

class LoadedProductInfoState extends HomeViewModel {
  const LoadedProductInfoState(Map<ProductInfoKey, String> productInfo)
      : super(productInfoMap: productInfo);
}

class HomeErrorState extends HomeViewModel {
  const HomeErrorState(this.errorMessage);

  final String errorMessage;
}
