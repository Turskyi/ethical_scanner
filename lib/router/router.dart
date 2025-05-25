import 'package:entities/entities.dart';
import 'package:ethical_scanner/camera_descriptions.dart' as cameras;
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/router/home_bloc_provider.dart';
import 'package:ethical_scanner/router/routes.dart' as route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

Route<String> generateRoute(RouteSettings settings) => switch (settings.name) {
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
              return const HomeBlocProvider();
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
  if (viewModel is ScanSuccessState) {
    Navigator.pop(context, viewModel.barcode);
  } else if (viewModel is CanceledScanningState) {
    Navigator.pop(context);
  }
}

PageRouteBuilder<String> _getHomePageRouteBuilder(RouteSettings settings) =>
    PageRouteBuilder<String>(
      settings: settings,
      pageBuilder: (
        BuildContext __,
        Animation<double> _,
        Animation<double> animation,
      ) {
        return Transform.translate(
          offset: Offset(
            AnimationConstants.transparentOpacityAnimation.value,
            animation.value * AnimationConstants.maxTranslationOffset.value,
          ),
          child: const HomeBlocProvider(),
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
