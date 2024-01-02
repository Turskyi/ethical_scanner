import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:interface_adapters/src/ui/modules/home/home_event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_cases/use_cases.dart';

part 'home_view_model.dart';

class HomePresenter extends Bloc<HomeEvent, HomeViewModel> {
  HomePresenter(this._getProductInfoUseCase) : super(const ReadyToScanState()) {
    on<ClearProductInfoEvent>(
      (_, Emitter<HomeViewModel> emit) => emit(const ReadyToScanState()),
    );

    on<NavigateToScanViewEvent>(
      (_, Emitter<HomeViewModel> emit) => emit(const ScanState()),
    );

    on<ShowProductInfoEvent>(
      (ShowProductInfoEvent event, Emitter<HomeViewModel> emit) async {
        final Map<ProductInfoKey, String> modifiableProductInfo =
            Map<ProductInfoKey, String>.from(state.productInfoMap);
        if (_isWebsite(event.code)) {
          modifiableProductInfo[ProductInfoKey.website] = event.code;
        } else {
          modifiableProductInfo[ProductInfoKey.code] = event.code;
          emit(LoadingProductInfoState(modifiableProductInfo));
          final ProductInfo productInfo = await _getProductInfoUseCase.call(
            event.code,
          );
          if (productInfo.name.isNotEmpty) {
            modifiableProductInfo[ProductInfoKey.productName] =
                productInfo.name;
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.origin.isNotEmpty) {
            modifiableProductInfo[ProductInfoKey.countryOfOrigin] =
                productInfo.origin;
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.country.isNotEmpty) {
            modifiableProductInfo[ProductInfoKey.countryWhereSold] =
                productInfo.country;
            emit(LoadingProductInfoState(modifiableProductInfo));
          } else if (productInfo.categoryTags.isNotEmpty) {
            StringBuffer stringBuffer = StringBuffer();
            for (String countryTag in productInfo.categoryTags) {
              stringBuffer.write(countryTag);
              if (countryTag != productInfo.categoryTags.last) {
                stringBuffer.write(', ');
              }
            }
            modifiableProductInfo[ProductInfoKey.countryWhereSold] =
                stringBuffer.toString();
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.brand.isNotEmpty) {
            modifiableProductInfo[ProductInfoKey.brand] = productInfo.brand;
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.vegetarian != Vegetarian.unknown) {
            modifiableProductInfo[ProductInfoKey.isVegetarian] =
                productInfo.vegetarian == Vegetarian.positive ? 'Yes' : 'No';
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.vegan != Vegan.unknown) {
            modifiableProductInfo[ProductInfoKey.isVegan] =
                productInfo.vegan == Vegan.positive ? 'Yes' : 'No';
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.packaging.isNotEmpty) {
            modifiableProductInfo[ProductInfoKey.packaging] =
                productInfo.packaging;
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.ingredientList.isNotEmpty) {
            StringBuffer stringBuffer = StringBuffer();
            for (String ingredient in productInfo.ingredientList) {
              stringBuffer.write(ingredient);
              if (ingredient != productInfo.ingredientList.last) {
                stringBuffer.write(', ');
              }
            }
            modifiableProductInfo[ProductInfoKey.ingredients] =
                stringBuffer.toString();
            emit(LoadingProductInfoState(modifiableProductInfo));
          }
          if (productInfo.website.isNotEmpty) {
            modifiableProductInfo[ProductInfoKey.website] = productInfo.website;
          }
        }
        emit(LoadedProductInfoState(modifiableProductInfo));
      },
    );

    on<LaunchUrlEvent>(
      (LaunchUrlEvent event, Emitter<HomeViewModel> emit) async {
        final Uri url = Uri.parse(event.uri);
        if (!await launchUrl(url)) {
          emit(HomeErrorState('Could not launch $url'));
        }
      },
    );

    on<ShowHomeEvent>(
      (ShowHomeEvent event, Emitter<HomeViewModel> emit) {
        emit(const ReadyToScanState());
      },
    );
  }

  final UseCase<Future<ProductInfo>, String> _getProductInfoUseCase;

  bool _isWebsite(String input) {
    // Regular expression for URL validation
    final RegExp regex = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]'
      r'{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
    );
    return regex.hasMatch(input);
  }
}
