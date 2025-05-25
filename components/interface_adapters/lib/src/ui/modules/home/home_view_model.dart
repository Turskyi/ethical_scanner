part of 'home_presenter.dart';

abstract class HomeViewModel {
  const HomeViewModel({
    this.isPrecipitationFalls = true,
    this.language = Language.en,
  });

  final Language language;
  final bool isPrecipitationFalls;

  @override
  String toString() {
    return 'HomeViewModel(language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
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

  @override
  String toString() {
    return 'ProductInfoState(productInfoMap: $productInfoMap, '
        'productInfo: $productInfo, language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
}

class LoadingHomeState extends HomeViewModel {
  const LoadingHomeState();

  @override
  String toString() {
    return 'LoadingHomeState(language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
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

  @override
  String toString() {
    return 'ReadyToScanState(language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
}

class ScanState extends HomeViewModel {
  const ScanState({super.language, super.isPrecipitationFalls});

  @override
  String toString() {
    return 'ScanState(language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
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

  @override
  String toString() {
    return 'LoadingProductInfoState(productInfoMap: $productInfoMap, '
        'language: $language, isPrecipitationFalls: $isPrecipitationFalls)';
  }
}

class LoadedProductInfoState extends ProductInfoState {
  const LoadedProductInfoState({
    super.productInfoMap,
    super.productInfo,
    super.language,
    super.isPrecipitationFalls,
  });

  @override
  String toString() {
    return 'LoadedProductInfoState(productInfoMap: $productInfoMap, '
        'productInfo: $productInfo, language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
}

class HomeErrorState extends HomeViewModel {
  const HomeErrorState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() {
    return 'HomeErrorState(errorMessage: $errorMessage, language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
}

class PhotoMakerState extends ProductInfoState {
  const PhotoMakerState({
    required super.productInfo,
    super.language,
    super.isPrecipitationFalls,
  });

  @override
  String toString() {
    return 'PhotoMakerState(productInfo: $productInfo, language: $language, '
        'isPrecipitationFalls: $isPrecipitationFalls)';
  }
}

final class FeedbackState extends LoadedProductInfoState {
  const FeedbackState({
    super.productInfoMap,
    super.productInfo,
    super.language,
    super.isPrecipitationFalls,
  });

  @override
  String toString() => 'FeedbackState(${super.toString()})';
}

final class FeedbackSent extends FeedbackState {
  const FeedbackSent();

  @override
  String toString() => 'FeedbackSent()';
}
