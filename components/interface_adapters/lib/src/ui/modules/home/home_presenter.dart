import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:interface_adapters/src/error_message_extractor.dart';
import 'package:interface_adapters/src/ui/modules/home/home_event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_cases/use_cases.dart';

part 'home_view_model.dart';

class HomePresenter extends Bloc<HomeEvent, HomeViewModel> {
  HomePresenter(
    this._getProductInfoUseCase,
    this._savePrecipitationStateUseCase,
    this._getPrecipitationStateUseCase,
    this._saveLanguageUseCase,
    this._getLanguageUseCase,
  ) : super(const LoadingHomeState()) {
    on<LoadHomeEvent>(
      (_, Emitter<HomeViewModel> emit) {
        emit(
          ReadyToScanState(
            isPrecipitationFalls: _getPrecipitationStateUseCase.call(),
            language: _getLanguageUseCase.call(),
          ),
        );
      },
    );

    on<ClearProductInfoEvent>(
      (_, Emitter<HomeViewModel> emit) {
        emit(
          ReadyToScanState(
            language: state.language,
            isPrecipitationFalls: state.isPrecipitationFalls,
          ),
        );
      },
    );

    on<NavigateToScanViewEvent>(
      (_, Emitter<HomeViewModel> emit) {
        if (state is ReadyToScanState) {
          ReadyToScanState readyToScanState = state as ReadyToScanState;
          emit(
            ScanState(
              language: readyToScanState.language,
              isPrecipitationFalls: readyToScanState.isPrecipitationFalls,
            ),
          );
        }
      },
    );

    on<ShowProductInfoEvent>(
      (ShowProductInfoEvent event, Emitter<HomeViewModel> emit) async {
        final Map<ProductInfoType, String> modifiableProductInfo =
            Map<ProductInfoType, String>.from(
          <ProductInfoType, String>{
            ProductInfoType.code: event.productInfo.barcode,
          },
        );
        emit(
          LoadingProductInfoState(
            productInfoMap: modifiableProductInfo,
            language: state.language,
            isPrecipitationFalls: state.isPrecipitationFalls,
          ),
        );
        ProductInfo productInfo = event.productInfo;
        try {
          if (_isWebsite(event.productInfo.barcode)) {
            modifiableProductInfo[ProductInfoType.website] =
                event.productInfo.barcode;
          } else {
            modifiableProductInfo[ProductInfoType.code] =
                event.productInfo.barcode;
            if (state is LoadingProductInfoState) {
              LoadingProductInfoState loadingState =
                  state as LoadingProductInfoState;
              emit(
                loadingState.copyWith(productInfoMap: modifiableProductInfo),
              );
            }

            productInfo = event.productInfo.ingredientList.isEmpty
                ? await _getProductInfoUseCase.call(
                    Barcode(
                      code: event.productInfo.barcode,
                      language: event.productInfo.language,
                    ),
                  )
                : event.productInfo;
            if (productInfo.name.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.productName] =
                  productInfo.name;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.origin.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.originCountry] =
                  productInfo.origin;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.country.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.countryWhereSold] =
                  productInfo.country;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            } else if (productInfo.categoryTags.isNotEmpty) {
              StringBuffer stringBuffer = StringBuffer();
              for (String countryTag in productInfo.categoryTags) {
                stringBuffer.write(countryTag);
                if (countryTag != productInfo.categoryTags.last) {
                  stringBuffer.write(', ');
                }
              }
              modifiableProductInfo[ProductInfoType.countryWhereSold] =
                  stringBuffer.toString();
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.brand.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.brand] = productInfo.brand;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.isCompanyTerrorismSponsor) {
              modifiableProductInfo[ProductInfoType.companyTerrorismSponsor] =
                  productInfo.isCompanyTerrorismSponsor
                      ? (state.language.isEnglish
                          ? 'Probably yes. '
                          : 'Напевно так. ')
                      : 'No';
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.isFromRussia) {
              modifiableProductInfo[ProductInfoType.countryTerrorismSponsor] =
                  'Yes';
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.vegetarian != Vegetarian.unknown) {
              modifiableProductInfo[ProductInfoType.isVegetarian] =
                  productInfo.vegetarian == Vegetarian.positive ? 'Yes' : 'No';
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.vegan != Vegan.unknown) {
              modifiableProductInfo[ProductInfoType.isVegan] =
                  productInfo.vegan == Vegan.positive ? 'Yes' : 'No';
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            if (productInfo.packaging.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.packaging] =
                  productInfo.packaging;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }

            StringBuffer stringBuffer = StringBuffer();
            for (String ingredient in productInfo.ingredientList) {
              stringBuffer.write(ingredient);
              if (ingredient != productInfo.ingredientList.last) {
                stringBuffer.write(', ');
              }
            }

            String ingredientsText = stringBuffer.toString();

            modifiableProductInfo[ProductInfoType.ingredients] =
                ingredientsText;

            if (state is LoadingProductInfoState) {
              LoadingProductInfoState loadingState =
                  state as LoadingProductInfoState;
              emit(
                loadingState.copyWith(productInfoMap: modifiableProductInfo),
              );
            }

            if (productInfo.website.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.website] =
                  productInfo.website;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }
            if (productInfo.countryAi.isNotEmpty) {
              modifiableProductInfo[ProductInfoType.countryAi] =
                  productInfo.countryAi;
              if (state is LoadingProductInfoState) {
                LoadingProductInfoState loadingState =
                    state as LoadingProductInfoState;
                emit(
                  loadingState.copyWith(productInfoMap: modifiableProductInfo),
                );
              }
            }
          }
        } catch (exception) {
          if (exception is FormatException && exception.source is String) {
            modifiableProductInfo[ProductInfoType.error] =
                extractErrorMessage(exception.source);
          } else {
            modifiableProductInfo[ProductInfoType.error] = '$exception';
          }
          if (state is LoadingProductInfoState) {
            LoadingProductInfoState loadingState =
                state as LoadingProductInfoState;
            emit(
              loadingState.copyWith(productInfoMap: modifiableProductInfo),
            );
          }
        } finally {
          emit(
            LoadedProductInfoState(
              isPrecipitationFalls: state.isPrecipitationFalls,
              language: state.language,
              productInfoMap: modifiableProductInfo,
              productInfo: productInfo,
            ),
          );
        }
      },
    );

    on<LaunchUrlEvent>(
      (LaunchUrlEvent event, Emitter<HomeViewModel> emit) async {
        final Uri url = Uri.parse(event.uri);
        if (!await launchUrl(url)) {
          emit(
            HomeErrorState(
              event.language.isEnglish
                  ? 'Could not launch $url'
                  : 'Не вдалося запустити $url',
            ),
          );
        }
      },
    );

    on<ShowHomeEvent>(
      (_, Emitter<HomeViewModel> emit) => emit(const ReadyToScanState()),
    );

    on<PrecipitationToggleEvent>((
      _,
      Emitter<HomeViewModel> emit,
    ) async {
      if (state is ReadyToScanState) {
        bool isPrecipitationFalls =
            !(state as ReadyToScanState).isPrecipitationFalls;
        bool isSaved =
            await _savePrecipitationStateUseCase.call(isPrecipitationFalls);
        if (isSaved) {
          emit(
            (state as ReadyToScanState).copyWith(
              isPrecipitationFalls: isPrecipitationFalls,
            ),
          );
        } else {
          emit(const LoadingHomeState());
        }
      }
    });

    on<SnapIngredientsEvent>(
      (_, Emitter<HomeViewModel> emit) {
        if (state is ProductInfoState) {
          ProductInfoState productInfoState = state as ProductInfoState;
          emit(
            PhotoMakerState(
              productInfo: productInfoState.productInfo,
              language: state.language,
              isPrecipitationFalls: state.isPrecipitationFalls,
            ),
          );
        }
      },
    );

    on<ChangeLanguageEvent>(
      (ChangeLanguageEvent event, Emitter<HomeViewModel> emit) async {
        Language language = event.language;
        bool isSaved =
            await _saveLanguageUseCase.call(language.isoLanguageCode);
        if (isSaved && state is ReadyToScanState) {
          emit((state as ReadyToScanState).copyWith(language: language));
        } else {
          emit(const LoadingHomeState());
        }
      },
    );
  }

  final UseCase<Future<ProductInfo>, Barcode> _getProductInfoUseCase;
  final UseCase<Future<bool>, bool> _savePrecipitationStateUseCase;
  final UseCase<bool, Null> _getPrecipitationStateUseCase;
  final UseCase<Future<bool>, String> _saveLanguageUseCase;
  final UseCase<Language, Null> _getLanguageUseCase;

  bool _isWebsite(String input) {
    // Regular expression for URL validation
    final RegExp regex = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]'
      r'{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
    );
    return regex.hasMatch(input);
  }
}
