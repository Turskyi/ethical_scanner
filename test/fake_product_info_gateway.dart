import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

class FakeProductInfoGateway implements ProductInfoGateway {
  const FakeProductInfoGateway({
    this.offProduct,
    this.leaveRussiaResponse,
    this.tourismSponsors = const <TerrorismSponsor>[],
    this.shouldThrowLeaveRussiaError = false,
    this.onGetLeaveRussiaInfo,
  });

  final ProductInfo? offProduct;
  final LeaveRussiaResponse? leaveRussiaResponse;
  final List<TerrorismSponsor> tourismSponsors;
  final bool shouldThrowLeaveRussiaError;
  final void Function(String barcode, Language language)? onGetLeaveRussiaInfo;

  FakeProductInfoGateway copyWith({
    ProductInfo? offProduct,
    LeaveRussiaResponse? leaveRussiaResponse,
    List<TerrorismSponsor>? tourismSponsors,
    bool? shouldThrowLeaveRussiaError,
    void Function(String barcode, Language language)? onGetLeaveRussiaInfo,
  }) {
    return FakeProductInfoGateway(
      offProduct: offProduct ?? this.offProduct,
      leaveRussiaResponse: leaveRussiaResponse ?? this.leaveRussiaResponse,
      tourismSponsors: tourismSponsors ?? this.tourismSponsors,
      shouldThrowLeaveRussiaError:
          shouldThrowLeaveRussiaError ?? this.shouldThrowLeaveRussiaError,
      onGetLeaveRussiaInfo: onGetLeaveRussiaInfo ?? this.onGetLeaveRussiaInfo,
    );
  }

  @override
  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode input) async {
    return offProduct ??
        ProductInfo(barcode: input.code, language: input.language);
  }

  @override
  Future<List<TerrorismSponsor>> getTerrorismSponsors() async {
    return tourismSponsors;
  }

  @override
  Future<LeaveRussiaResponse?> getLeaveRussiaInfo({
    required String barcode,
    required Language language,
  }) async {
    onGetLeaveRussiaInfo?.call(barcode, language);

    if (shouldThrowLeaveRussiaError) {
      throw Exception('Network error');
    }
    return leaveRussiaResponse;
  }

  @override
  Future<void> addIngredients(ProductPhoto productPhoto) async {}

  @override
  Future<void> addProduct(ProductInfo productInfo) async {}

  @override
  Future<String> extractIngredients(ProductPhoto productPhoto) async => '';

  @override
  Future<void> saveIngredients({
    required String barcode,
    required String ingredientsText,
    required Language language,
  }) async {}
}
