import 'package:entities/entities.dart';
import 'package:ethical_scanner/camera_descriptions.dart' as cameras;
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/routes/routes.dart' as route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

Route<String> generateRoute(RouteSettings settings) => switch (settings.name) {
      route.homePath => _getHomePageRouteBuilder(settings),
      route.scanPath => PageRouteBuilder<String>(
          opaque: false,
          pageBuilder: (
            _,
            Animation<double> animation,
            Animation<double> __,
          ) =>
              BlocProvider<ScanPresenter>(
            create: (BuildContext context) {
              Dependencies dependencies = DependenciesScope.of(context);
              return ScanPresenter(
                dependencies.saveSoundPreferenceUseCase,
                dependencies.getSoundPreferenceUseCase,
              )..add(const LoadScannerEvent());
            },
            child: BlocListener<ScanPresenter, ScanViewModel>(
              listener: (BuildContext context, ScanViewModel viewModel) {
                if (viewModel is ScanSuccessState) {
                  Navigator.pop(context, viewModel.barcode);
                } else if (viewModel is CanceledScanningState) {
                  Navigator.pop(context);
                }
              },
              child: Opacity(
                opacity: animation.value,
                child: const ScanView(),
              ),
            ),
          ),
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) =>
              FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
        ),
      route.photoPath => PageRouteBuilder<String>(
          pageBuilder: (BuildContext context, _, __) {
            Object? args = settings.arguments;
            if (args is ProductInfo) {
              return BlocProvider<PhotoPresenter>(
                create: (_) => PhotoPresenter(
                  DependenciesScope.of(context).addIngredientsUseCase,
                ),
                child: BlocListener<PhotoPresenter, PhotoViewModel>(
                  listener: (BuildContext context, PhotoViewModel viewModel) {
                    if (viewModel is IngredientsAddedSuccessState) {
                      Navigator.pop(context);
                    } else if (viewModel is CanceledPhotoState) {
                      Navigator.pop(context);
                    }
                  },
                  child: PhotoView(
                    productInfo: args,
                    cameraDescriptions: cameras.cameraDescriptions,
                  ),
                ),
              );
            } else {
              return const HomeBlocProvider();
            }
          },
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) =>
              FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
        ),
      _ => _getHomePageRouteBuilder(settings),
    };

PageRouteBuilder<String> _getHomePageRouteBuilder(RouteSettings settings) =>
    PageRouteBuilder<String>(
      settings: settings,
      pageBuilder: (
        BuildContext context,
        Animation<double> _,
        Animation<double> animation,
      ) =>
          Transform.translate(
        offset: Offset(
          _transparentOpacityAnimation,
          animation.value * _maxTranslationOffset,
        ),
        child: const HomeBlocProvider(),
      ),
      transitionsBuilder: (
        _,
        Animation<double> animation,
        __,
        Widget child,
      ) =>
          FadeTransition(opacity: animation, child: child),
    );

class HomeBlocProvider extends StatelessWidget {
  const HomeBlocProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePresenter>(
      create: (BuildContext context) {
        Dependencies dependencies = DependenciesScope.of(context);
        return HomePresenter(
          dependencies.productInfoUseCase,
          dependencies.savePrecipitationStateUseCase,
          dependencies.getPrecipitationStateUseCase,
          dependencies.saveLanguageUseCase,
          dependencies.getLanguageUseCase,
        )..add(const LoadHomeEvent());
      },
      child: BlocListener<HomePresenter, HomeViewModel>(
        listener: (BuildContext context, HomeViewModel viewModel) {
          Language language = Language.fromIsoLanguageCode(
            viewModel.language.isoLanguageCode,
          );
          if (viewModel is ScanState) {
            Navigator.pushNamed<String>(context, route.scanPath).then(
              (String? barcode) {
                _displayProductInfoOrHome(
                  context: context,
                  productInfo: ProductInfo(
                    barcode: barcode ?? '',
                    language: language,
                  ),
                );
              },
            );
          } else if (viewModel is PhotoMakerState) {
            Navigator.pushNamed<void>(
              context,
              route.photoPath,
              arguments: viewModel.productInfo,
            ).then(
              (_) => _displayProductInfoOrHome(
                context: context,
                productInfo: viewModel.productInfo,
              ),
            );
          } else if (viewModel is ReadyToScanState) {
            Language currentLanguage = Language.fromIsoLanguageCode(
              LocalizedApp.of(context).delegate.currentLocale.languageCode,
            );
            Language savedLanguage = viewModel.language;
            if (currentLanguage != savedLanguage) {
              changeLocale(context, savedLanguage.isoLanguageCode)
                  // The returned value in `then` is always `null`.
                  .then((_) {
                context
                    .read<HomePresenter>()
                    .add(ChangeLanguageEvent(savedLanguage));
              });
            }
          }
        },
        child: const HomeView(),
      ),
    );
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

const double _transparentOpacityAnimation = 0.0;
const double _maxTranslationOffset = 100.0;
