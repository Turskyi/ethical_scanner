import 'package:entities/entities.dart';
import 'package:ethical_scanner/camera_descriptions.dart' as cameras;
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/router/routes.dart' as route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

Route<String> generateRoute(RouteSettings settings) {
  final String? routePath = settings.name;

  return switch (routePath) {
    route.homePath => _getHomePageRouteBuilder(settings),
    route.scanPath => PageRouteBuilder<String>(
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
              return ScanPresenter(
                dependencies.saveSoundPreferenceUseCase,
                dependencies.getSoundPreferenceUseCase,
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
    route.photoPath => PageRouteBuilder<String>(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation, __) {
          final Object? args = settings.arguments;
          if (args is ProductInfo) {
            return BlocProvider<PhotoPresenter>(
              create: (_) => PhotoPresenter(
                DependenciesScope.of(context).addIngredientsUseCase,
              ),
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
                final Dependencies dependencies = DependenciesScope.of(context);
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
    _ => _getHomePageRouteBuilder(settings),
  };
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
    Navigator.pop(context);
  } else if (viewModel is CanceledPhotoState) {
    Navigator.pop(context);
  }
}

void _scanViewModelListener(BuildContext context, ScanViewModel viewModel) {
  final String targetRouteName = route.homePath;

  if (viewModel is ScanSuccessState) {
    Navigator.of(context).pushReplacementNamed(
      targetRouteName,
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
    Navigator.pushNamed<String>(context, route.scanPath).then(
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
    Navigator.pushNamed<void>(
      context,
      route.photoPath,
      arguments: viewModel.productInfo,
    ).then(
      (_) {
        if (context.mounted) {
          context.read<HomePresenter>().add(
                const ClearProductInfoEvent(),
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
    context.read<HomePresenter>().add(const ClearProductInfoEvent());
  }
}
