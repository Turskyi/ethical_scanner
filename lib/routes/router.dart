import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

Route<String> generateRoute(RouteSettings settings) => switch (settings.name) {
      home => PageRouteBuilder<String>(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> _,
            Animation<double> outAnimation,
          ) =>
              Transform.translate(
            offset: Offset(0.0, outAnimation.value * 100.0),
            child: BlocProvider<HomePresenter>(
              create: (BuildContext context) => HomePresenter(
                DependenciesScope.of(context).productInfoUseCase,
                DependenciesScope.of(context).savePrecipitationStateUseCase,
                DependenciesScope.of(context).getPrecipitationStateUseCase,
              )..add(const LoadHomeEvent()),
              child: BlocListener<HomePresenter, HomeViewModel>(
                listener: (BuildContext context, HomeViewModel viewModel) {
                  if (viewModel is ScanState) {
                    Navigator.pushNamed<String>(context, AppRoute.scan.path)
                        .then(
                      (String? barcode) => _displayProductInfoOrHome(
                        context: context,
                        barcode: barcode ?? '',
                      ),
                    );
                  } else if (viewModel is PhotoMakerState) {
                    Navigator.pushNamed<String>(context, AppRoute.photo.path)
                        .then(
                      (String? barcode) => _displayProductInfoOrHome(
                        context: context,
                        barcode: barcode ?? '',
                      ),
                    );
                  }
                },
                child: const HomeView(),
              ),
            ),
          ),
          transitionsBuilder: (
            _,
            Animation<double> animation,
            __,
            Widget child,
          ) =>
              FadeTransition(opacity: animation, child: child),
        ),
      // home => PageRouteBuilder<String>(
      //     settings: settings,
      //     pageBuilder: (
      //       BuildContext context,
      //       Animation<double> _,
      //       Animation<double> __,
      //     ) =>
      //         BlocProvider<HomePresenter>(
      //       create: (BuildContext context) => HomePresenter(
      //         DependenciesScope.of(context).productInfoUseCase,
      //         DependenciesScope.of(context).savePrecipitationStateUseCase,
      //         DependenciesScope.of(context).getPrecipitationStateUseCase,
      //       )..add(const LoadHomeEvent()),
      //       child: BlocListener<HomePresenter, HomeViewModel>(
      //         listener: (BuildContext context, HomeViewModel viewModel) {
      //           if (viewModel is ScanState) {
      //             Navigator.pushNamed<String>(context, AppRoute.scan.path).then(
      //               (String? barcode) => _displayProductInfoOrHome(
      //                 context: context,
      //                 barcode: barcode ?? '',
      //               ),
      //             );
      //           } else if (viewModel is PhotoMakerState) {
      //             Navigator.pushNamed<String>(context, AppRoute.photo.path)
      //                 .then(
      //               (String? barcode) => _displayProductInfoOrHome(
      //                 context: context,
      //                 barcode: barcode ?? '',
      //               ),
      //             );
      //           }
      //         },
      //         child: const HomeView(),
      //       ),
      //     ),
      //     transitionsBuilder: (
      //       _,
      //       Animation<double> animation,
      //       __,
      //       Widget child,
      //     ) =>
      //         FadeTransition(opacity: animation, child: child),
      //   ),
      scan => PageRouteBuilder<String>(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              BlocProvider<ScanPresenter>(
            create: (_) => ScanPresenter(),
            child: BlocListener<ScanPresenter, ScanViewModel>(
              listener: (BuildContext context, ScanViewModel viewModel) {
                if (viewModel is ScanSuccessState) {
                  Navigator.pop(context, viewModel.barcode);
                } else if (viewModel is CanceledScanningState) {
                  Navigator.popAndPushNamed(context, AppRoute.home.path);
                }
              },
              child: const ScanView(),
            ),
          ),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) =>
                  FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
        ),
      _ => MaterialPageRoute<String>(builder: (_) => const HomeView()),
    };

void _displayProductInfoOrHome({
  required BuildContext context,
  required String barcode,
}) {
  if (barcode.isNotEmpty) {
    context.read<HomePresenter>().add(
          ShowProductInfoEvent(
            Barcode(
              code: barcode,
              language: Language.fromLanguageCode(
                LocalizedApp.of(context).delegate.currentLocale.languageCode,
              ),
            ),
          ),
        );
  } else {
    context.read<HomePresenter>().add(const ShowHomeEvent());
  }
}
