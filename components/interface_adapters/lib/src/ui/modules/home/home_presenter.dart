import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:interface_adapters/src/error_message_extractor.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_cases/use_cases.dart';

part 'home_event.dart';
part 'home_view_model.dart';

class HomePresenter extends Bloc<HomeEvent, HomeViewModel> {
  HomePresenter(
    this._getProductInfoUseCase,
    this._savePrecipitationStateUseCase,
    this._getPrecipitationStateUseCase,
    this._saveLanguageUseCase,
    this._getLanguageUseCase,
  ) : super(const LoadingHomeState()) {
    on<LoadHomeEvent>(_onLoadHomeEvent);

    on<ClearProductInfoEvent>(_onClearProductInfoEvent);

    on<NavigateToScanViewEvent>(_onNavigateToScanViewEvent);

    on<ShowProductInfoEvent>(_onShowProductInfoEvent);

    on<LaunchUrlEvent>(_handleLaunchUrl);

    on<ShowHomeEvent>(_onShowHomeEvent);

    on<PrecipitationToggleEvent>(_togglePrecipitationSetting);

    on<SnapIngredientsEvent>(_startPhotoMaker);

    on<ChangeLanguageEvent>(_changeLanguage);

    on<BugReportPressedEvent>(_onFeedbackRequested);

    on<SubmitFeedbackEvent>(_sendUserFeedback);

    on<HomeErrorEvent>(_handleError);
  }

  final UseCase<Future<ProductInfo>, LocalizedCode> _getProductInfoUseCase;
  final UseCase<Future<bool>, bool> _savePrecipitationStateUseCase;
  final UseCase<bool, Null> _getPrecipitationStateUseCase;
  final UseCase<Future<bool>, String> _saveLanguageUseCase;
  final UseCase<Language, Null> _getLanguageUseCase;

  FutureOr<void> _onShowHomeEvent(
    ShowHomeEvent _,
    Emitter<HomeViewModel> emit,
  ) {
    emit(const ReadyToScanState());
  }

  FutureOr<void> _handleError(
    HomeErrorEvent event,
    Emitter<HomeViewModel> emit,
  ) {
    emit(HomeErrorState(event.error));
  }

  FutureOr<void> _changeLanguage(
    ChangeLanguageEvent event,
    Emitter<HomeViewModel> emit,
  ) async {
    final Language language = event.language;
    if (language != state.language) {
      final bool isSaved = await _saveLanguageUseCase.call(
        language.isoLanguageCode,
      );
      if (isSaved && state is ReadyToScanState) {
        emit((state as ReadyToScanState).copyWith(language: language));
      } else {
        emit(const LoadingHomeState());
      }
    }
  }

  FutureOr<void> _startPhotoMaker(_, Emitter<HomeViewModel> emit) {
    if (state is ProductInfoState) {
      final ProductInfoState productInfoState = state as ProductInfoState;
      emit(
        PhotoMakerState(
          productInfo: productInfoState.productInfo,
          language: state.language,
          isPrecipitationFalls: state.isPrecipitationFalls,
        ),
      );
    }
  }

  FutureOr<void> _togglePrecipitationSetting(
    _,
    Emitter<HomeViewModel> emit,
  ) async {
    if (state is ReadyToScanState) {
      final bool toggledValue =
          !(state as ReadyToScanState).isPrecipitationFalls;
      final bool isSaved = await _savePrecipitationStateUseCase.call(
        toggledValue,
      );
      if (isSaved) {
        emit(
          (state as ReadyToScanState).copyWith(
            isPrecipitationFalls: toggledValue,
          ),
        );
      } else {
        emit(const LoadingHomeState());
      }
    }
  }

  FutureOr<void> _handleLaunchUrl(
    LaunchUrlEvent event,
    Emitter<HomeViewModel> emit,
  ) async {
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
  }

  FutureOr<void> _onClearProductInfoEvent(_, Emitter<HomeViewModel> emit) {
    emit(
      ReadyToScanState(
        language: state.language,
        isPrecipitationFalls: state.isPrecipitationFalls,
      ),
    );
  }

  FutureOr<void> _onLoadHomeEvent(_, Emitter<HomeViewModel> emit) {
    emit(
      ReadyToScanState(
        isPrecipitationFalls: _getPrecipitationStateUseCase.call(),
        language: _getLanguageUseCase.call(),
      ),
    );
  }

  FutureOr<void> _onNavigateToScanViewEvent(_, Emitter<HomeViewModel> emit) {
    if (state is ReadyToScanState) {
      final ReadyToScanState readyToScanState = state as ReadyToScanState;
      emit(
        ScanState(
          language: readyToScanState.language,
          isPrecipitationFalls: readyToScanState.isPrecipitationFalls,
        ),
      );
    }
  }

  FutureOr<void> _onShowProductInfoEvent(
    ShowProductInfoEvent event,
    Emitter<HomeViewModel> emit,
  ) async {
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

    // The `productInfo` variable is intentionally kept mutable here.
    // Making it `final` would require additional variables and complexity
    // to handle reassignment, which would reduce the readability and
    // simplicity of the code.
    ProductInfo productInfo = event.productInfo;
    try {
      if (_isWebsite(event.productInfo.barcode)) {
        modifiableProductInfo[ProductInfoType.website] =
            event.productInfo.barcode;
      } else {
        modifiableProductInfo[ProductInfoType.code] = event.productInfo.barcode;
        if (state is LoadingProductInfoState) {
          LoadingProductInfoState loadingState =
              state as LoadingProductInfoState;
          emit(
            loadingState.copyWith(productInfoMap: modifiableProductInfo),
          );
        }

        productInfo = event.productInfo.ingredientList.isEmpty
            ? await _getProductInfoUseCase.call(
                LocalizedCode(
                  code: event.productInfo.barcode,
                  language: event.productInfo.language,
                ),
              )
            : event.productInfo;
        if (productInfo.name.isNotEmpty) {
          modifiableProductInfo[ProductInfoType.productName] = productInfo.name;
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

        if (productInfo.countrySold.isNotEmpty) {
          modifiableProductInfo[ProductInfoType.countryWhereSold] =
              productInfo.countrySold;
          if (state is LoadingProductInfoState) {
            LoadingProductInfoState loadingState =
                state as LoadingProductInfoState;
            emit(
              loadingState.copyWith(productInfoMap: modifiableProductInfo),
            );
          }
        } else if (productInfo.categoryTags.isNotEmpty) {
          final StringBuffer stringBuffer = StringBuffer();
          for (final String countryTag in productInfo.categoryTags) {
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
            final LoadingProductInfoState loadingState =
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
            final LoadingProductInfoState loadingState =
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
            final LoadingProductInfoState loadingState =
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
            final LoadingProductInfoState loadingState =
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
            final LoadingProductInfoState loadingState =
                state as LoadingProductInfoState;
            emit(
              loadingState.copyWith(productInfoMap: modifiableProductInfo),
            );
          }
        }

        final StringBuffer stringBuffer = StringBuffer();
        for (final String ingredient in productInfo.ingredientList) {
          stringBuffer.write(ingredient);
          if (ingredient != productInfo.ingredientList.last) {
            stringBuffer.write(', ');
          }
        }

        if (!productInfo.isEnglishBook) {
          final String ingredientsText = stringBuffer.toString();

          modifiableProductInfo[ProductInfoType.ingredients] = ingredientsText;
        }

        if (state is LoadingProductInfoState) {
          final LoadingProductInfoState loadingState =
              state as LoadingProductInfoState;
          emit(
            loadingState.copyWith(productInfoMap: modifiableProductInfo),
          );
        }

        if (productInfo.website.isNotEmpty) {
          modifiableProductInfo[ProductInfoType.website] = productInfo.website;
          if (state is LoadingProductInfoState) {
            final LoadingProductInfoState loadingState =
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
            final LoadingProductInfoState loadingState =
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
        final LoadingProductInfoState loadingState =
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
  }

  FutureOr<void> _onFeedbackRequested(_, Emitter<HomeViewModel> emit) {
    if (state is LoadedProductInfoState) {
      final LoadedProductInfoState viewModel = state as LoadedProductInfoState;
      emit(
        FeedbackState(
          productInfoMap: viewModel.productInfoMap,
          productInfo: viewModel.productInfo,
          language: viewModel.language,
          isPrecipitationFalls: viewModel.isPrecipitationFalls,
        ),
      );
    }
  }

  FutureOr<void> _sendUserFeedback(
    SubmitFeedbackEvent event,
    Emitter<HomeViewModel> emit,
  ) async {
    final UserFeedback feedback = event.feedback;
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final String platform = kIsWeb
          ? 'Web'
          : switch (defaultTargetPlatform) {
              TargetPlatform.android => 'Android',
              TargetPlatform.iOS => 'iOS',
              TargetPlatform.macOS => 'macOS',
              TargetPlatform.windows => 'Windows',
              TargetPlatform.linux => 'Linux',
              _ => 'Unknown',
            };

      final Map<String, Object?>? extra = feedback.extra;
      final Object? rating = extra?['rating'];
      final Object? type = extra?['feedback_type'];

      final bool isFeedbackType = type is FeedbackType;
      final bool isFeedbackRating = rating is FeedbackRating;
      // Construct the feedback text with details from `extra'.
      final StringBuffer feedbackBody = StringBuffer()
        ..writeln('${isFeedbackType ? 'Feedback Type' : ''}:'
            ' ${isFeedbackType ? type.value : ''}')
        ..writeln()
        ..writeln(feedback.text)
        ..writeln()
        ..writeln('${isFeedbackRating ? 'Rating' : ''}'
            '${isFeedbackRating ? ':' : ''}'
            ' ${isFeedbackRating ? rating.value : ''}')
        ..writeln()
        ..writeln('App id: ${packageInfo.packageName}')
        ..writeln('App version: ${packageInfo.version}')
        ..writeln('Build number: ${packageInfo.buildNumber}')
        ..writeln()
        ..writeln('Platform: $platform')
        ..writeln();
      if (kIsWeb || Platform.isMacOS) {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: kSupportEmail,
          queryParameters: <String, Object?>{
            'subject': 'App Feedback: ${packageInfo.appName}',
            'body': feedbackBody.toString(),
          },
        );
        try {
          if (await canLaunchUrl(emailLaunchUri)) {
            await launchUrl(emailLaunchUri);
          } else {
            throw 'Could not launch email with url_launcher.';
          }
        } catch (urlLauncherError, urlLauncherStackTrace) {
          final String urlLauncherErrorMessage =
              'Error launching email via url_launcher: $urlLauncherError';
          debugPrint(
            '$urlLauncherErrorMessage\nStackTrace: $urlLauncherStackTrace',
          );
          // TODO: show an error message to the user.
        }
      } else {
        final String screenshotFilePath = await _writeImageToStorage(
          feedback.screenshot,
        );
        final Email email = Email(
          subject: 'App Feedback: ${packageInfo.appName}',
          body: feedbackBody.toString(),
          recipients: <String>[kSupportEmail],
          attachmentPaths: <String>[screenshotFilePath],
        );
        try {
          await FlutterEmailSender.send(email);
        } catch (e, stackTrace) {
          debugPrint(
            'Warning: an error occurred in $this: $e;\nStackTrace: $stackTrace',
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('SettingsErrorEvent: $e\nStackTrace: $stackTrace');
      add(
        const HomeErrorEvent(
          'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  bool _isWebsite(String input) {
    // Regular expression for URL validation
    final RegExp regex = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]'
      r'{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
    );
    return regex.hasMatch(input);
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
