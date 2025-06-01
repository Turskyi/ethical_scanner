part of 'home_presenter.dart';

abstract class HomeViewModel {
  const HomeViewModel({
    this.isSeasonalEffectEnabled = true,
    this.language = Language.en,
  });

  final Language language;
  final bool isSeasonalEffectEnabled;

  @override
  String toString() {
    return 'HomeViewModel(language: $language, '
        'isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

abstract class ProductInfoState extends HomeViewModel {
  const ProductInfoState({
    this.productInfoMap = const <ProductInfoType, String>{},
    this.productInfo = const ProductInfo(),
    super.language,
    super.isSeasonalEffectEnabled,
  });

  final Map<ProductInfoType, String> productInfoMap;
  final ProductInfo productInfo;

  @override
  String toString() {
    return 'ProductInfoState(productInfoMap: $productInfoMap, '
        'productInfo: $productInfo, language: $language, '
        'isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

class LoadingHomeState extends HomeViewModel {
  const LoadingHomeState();

  @override
  String toString() {
    return 'LoadingHomeState(language: $language, '
        'isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

class ReadyToScanState extends HomeViewModel {
  const ReadyToScanState({
    required super.language,
    super.isSeasonalEffectEnabled,
  });

  ReadyToScanState copyWith({
    Language? language,
    bool? isSeasonalEffectEnabled,
  }) =>
      ReadyToScanState(
        language: language ?? this.language,
        isSeasonalEffectEnabled:
            isSeasonalEffectEnabled ?? this.isSeasonalEffectEnabled,
      );

  @override
  String toString() {
    return 'ReadyToScanState(language: $language, '
        'isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

class ScanState extends HomeViewModel {
  const ScanState({super.language, super.isSeasonalEffectEnabled});

  @override
  String toString() {
    return 'ScanState(language: $language, '
        'isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

class LoadingProductInfoState extends ProductInfoState {
  const LoadingProductInfoState({
    required super.language,
    super.productInfoMap,
    super.isSeasonalEffectEnabled,
  });

  LoadingProductInfoState copyWith({
    Map<ProductInfoType, String>? productInfoMap,
    Language? language,
    bool? isSeasonalEffectEnabled,
  }) =>
      LoadingProductInfoState(
        productInfoMap: productInfoMap ?? this.productInfoMap,
        language: language ?? this.language,
        isSeasonalEffectEnabled:
            isSeasonalEffectEnabled ?? this.isSeasonalEffectEnabled,
      );

  @override
  String toString() {
    return 'LoadingProductInfoState(productInfoMap: $productInfoMap, '
        'language: $language, isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

class LoadedProductInfoState extends ProductInfoState {
  const LoadedProductInfoState({
    super.productInfoMap,
    super.productInfo,
    super.language,
    super.isSeasonalEffectEnabled,
  });

  @override
  String toString() {
    return 'LoadedProductInfoState(productInfoMap: $productInfoMap, '
        'productInfo: $productInfo, language: $language, '
        'isSeasonalEffectEnabled: $isSeasonalEffectEnabled)';
  }
}

class HomeErrorState extends HomeViewModel {
  const HomeErrorState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() {
    return 'HomeErrorState(errorMessage: $errorMessage, language: $language, '
        'isPrecipitationFalls: $isSeasonalEffectEnabled)';
  }
}

class PhotoMakerState extends ProductInfoState {
  const PhotoMakerState({
    required super.productInfo,
    super.language,
    super.isSeasonalEffectEnabled,
  });

  @override
  String toString() {
    return 'PhotoMakerState(productInfo: $productInfo, language: $language, '
        'isSeasonalEffectEnabled: $isSeasonalEffectEnabled)';
  }
}

final class FeedbackState extends LoadedProductInfoState {
  const FeedbackState({
    super.productInfoMap,
    super.productInfo,
    super.language,
    super.isSeasonalEffectEnabled,
  });

  @override
  String toString() => 'FeedbackState(${super.toString()})';
}

final class FeedbackSent extends FeedbackState {
  const FeedbackSent();

  @override
  String toString() => 'FeedbackSent()';
}
