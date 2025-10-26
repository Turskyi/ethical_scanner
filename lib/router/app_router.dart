import 'package:entities/entities.dart';
import 'package:ethical_scanner/camera_descriptions.dart' as cameras;
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

class AppRouter {
  const AppRouter({required this.savedLanguage});

  final Language savedLanguage;

  Route<Object> generateRoute(RouteSettings settings) {
    final String? routePath = settings.name;

    return switch (routePath) {
      kHomePath => _getHomePageRouteBuilder(settings),
      kScanPath => PageRouteBuilder<String>(
          settings: settings,
          opaque: false,
          pageBuilder: (
            _,
            Animation<double> animation,
            Animation<double> __,
          ) {
            return BlocProvider<ScanPresenter>(
              create: (BuildContext context) {
                final Dependencies dependencies = DependenciesScope.of(context);
                final Language initialLanguage = Language.fromIsoLanguageCode(
                  LocalizedApp.of(context).delegate.currentLocale.languageCode,
                );
                return ScanPresenter(
                  dependencies.saveSoundPreferenceUseCase,
                  dependencies.getSoundPreferenceUseCase,
                  dependencies.saveLanguageUseCase,
                  initialLanguage,
                )..add(const LoadScannerEvent());
              },
              child: BlocListener<ScanPresenter, ScanViewModel>(
                listener: _scanViewModelListener,
                child: Opacity(
                  opacity: animation.value,
                  child: const ScanView(),
                ),
              ),
            );
          },
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      kPhotoPath => PageRouteBuilder<Language>(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> __,
          ) {
            final Object? args = settings.arguments;
            if (args is ProductInfo) {
              final Dependencies dependencies = DependenciesScope.of(context);
              return BlocProvider<PhotoPresenter>(
                create: (BuildContext context) {
                  final Language initialLanguage = Language.fromIsoLanguageCode(
                    LocalizedApp.of(context)
                        .delegate
                        .currentLocale
                        .languageCode,
                  );
                  return PhotoPresenter(
                    dependencies.addIngredientsUseCase,
                    dependencies.saveLanguageUseCase,
                    initialLanguage,
                  );
                },
                child: BlocListener<PhotoPresenter, PhotoViewModel>(
                  listener: _photoViewModelListener,
                  child: FadeTransition(
                    // Use the animation parameter to control `opacity`.
                    opacity: animation,
                    child: PhotoView(
                      productInfo: args,
                      cameraDescriptions: cameras.cameraDescriptions,
                    ),
                  ),
                ),
              );
            } else {
              return BlocProvider<HomePresenter>(
                create: (BuildContext context) {
                  final Dependencies dependencies =
                      DependenciesScope.of(context);
                  return HomePresenter(
                    dependencies.productInfoUseCase,
                    dependencies.savePrecipitationStateUseCase,
                    dependencies.getPrecipitationStateUseCase,
                    dependencies.saveLanguageUseCase,
                    dependencies.getLanguageUseCase,
                  )..add(const LoadHomeEvent());
                },
                child: BlocListener<HomePresenter, HomeViewModel>(
                  listener: _homeViewModelListener,
                  child: const HomeView(),
                ),
              );
            }
          },
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      kPrivacyPath => PageRouteBuilder<String>(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> __,
          ) {
            return PrivacyView(initialLanguage: savedLanguage);
          },
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      String? _ => _getHomePageRouteBuilder(settings),
    };
  }
}

void _photoViewModelListener(BuildContext context, PhotoViewModel viewModel) {
  if (viewModel is IngredientsAddedSuccessState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          translate('photo.image_upload_successful'),
        ),
        duration: Duration(
          seconds: DurationSeconds.long.time,
        ),
      ),
    );
    Navigator.of(context).pop(viewModel.language);
  } else if (viewModel is CanceledPhotoState) {
    Navigator.of(context).pop(viewModel.language);
  }
}

void _scanViewModelListener(BuildContext context, ScanViewModel viewModel) {
  final String targetRouteName = kHomePath;

  if (viewModel is ScanSuccessState) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      targetRouteName,
      (Route<Object?> _) => false,
      arguments: viewModel.barcode,
    );
  } else if (viewModel is CanceledScanningState) {
    Navigator.popUntil(context, ModalRoute.withName(targetRouteName));
  }
}

PageRouteBuilder<String> _getHomePageRouteBuilder(RouteSettings settings) {
  return PageRouteBuilder<String>(
    settings: settings,
    pageBuilder: (
      BuildContext context,
      Animation<double> _,
      Animation<double> animation,
    ) {
      return BlocProvider<HomePresenter>(
        create: (BuildContext context) {
          final Dependencies dependencies = DependenciesScope.of(context);
          final HomePresenter homePresenter = HomePresenter(
            dependencies.productInfoUseCase,
            dependencies.savePrecipitationStateUseCase,
            dependencies.getPrecipitationStateUseCase,
            dependencies.saveLanguageUseCase,
            dependencies.getLanguageUseCase,
          );
          final Object? arguments = settings.arguments;

          if (arguments is String) {
            final Language language = Language.fromIsoLanguageCode(
              LocalizedApp.of(context).delegate.currentLocale.languageCode,
            );

            final ProductInfo productInfo = ProductInfo(
              // Assume that the arguments is a barcode.
              barcode: arguments,
              language: language,
            );

            return homePresenter..add(ShowProductInfoEvent(productInfo));
          } else {
            return homePresenter..add(const LoadHomeEvent());
          }
        },
        child: BlocListener<HomePresenter, HomeViewModel>(
          listener: _homeViewModelListener,
          child: const HomeView(),
        ),
      );
    },
    transitionsBuilder: (
      _,
      Animation<double> animation,
      __,
      Widget child,
    ) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

void _homeViewModelListener(BuildContext context, HomeViewModel viewModel) {
  final Language language = Language.fromIsoLanguageCode(
    viewModel.language.isoLanguageCode,
  );

  if (viewModel is ScanState) {
    Navigator.pushNamed<String>(context, kScanPath).then(
      (String? barcode) {
        if (context.mounted) {
          _displayProductInfoOrHome(
            context: context,
            productInfo: ProductInfo(
              barcode: barcode ?? '',
              language: language,
            ),
          );
        }
      },
    );
  } else if (viewModel is PhotoMakerState) {
    Navigator.pushNamed<Language>(
      context,
      kPhotoPath,
      arguments: viewModel.productInfo,
    ).then(
      (Language? language) {
        if (context.mounted) {
          context.read<HomePresenter>().add(
                ClearProductInfoEvent(language ?? Language.en),
              );
        }
      },
    );
  } else if (viewModel is ReadyToScanState) {
    final Language currentLanguage = Language.fromIsoLanguageCode(
      LocalizedApp.of(context).delegate.currentLocale.languageCode,
    );
    final Language savedLanguage = viewModel.language;

    if (currentLanguage != savedLanguage) {
      changeLocale(context, savedLanguage.isoLanguageCode)
          // The returned value in `then` is always `null`.
          .then((void _) {
        if (context.mounted) {
          context.read<HomePresenter>().add(ChangeLanguageEvent(savedLanguage));
        }
      });
    }
  }
}

void _displayProductInfoOrHome({
  required BuildContext context,
  required ProductInfo productInfo,
}) {
  if (productInfo.barcode.isNotEmpty) {
    context.read<HomePresenter>().add(ShowProductInfoEvent(productInfo));
  } else {
    context.read<HomePresenter>().add(
          ClearProductInfoEvent(productInfo.language),
        );
  }
}
