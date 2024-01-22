import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_adapters/interface_adapters.dart';

Route<String> generateRoute(RouteSettings settings) {
  if (settings.name == AppRoute.home.path) {
    return PageRouteBuilder<String>(
      settings: settings,
      pageBuilder: (BuildContext context, __, ___) =>
          BlocProvider<HomePresenter>(
        create: (BuildContext context) => HomePresenter(
          DependenciesScope.of(context).productInfoUseCase,
          DependenciesScope.of(context).savePrecipitationStateUseCase,
          DependenciesScope.of(context).getPrecipitationStateUseCase,
        )..add(const LoadHomeEvent()),
        child: BlocListener<HomePresenter, HomeViewModel>(
          listener: (BuildContext context, HomeViewModel viewModel) {
            if (viewModel is ScanState) {
              Navigator.pushNamed<String>(context, AppRoute.scan.path)
                  .then((String? barcode) {
                _displayProductInfoOrHome(context: context, barcode: barcode);
              });
            }
          },
          child: const HomeView(),
        ),
      ),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
          FadeTransition(opacity: animation, child: child),
    );
  } else if (settings.name == AppRoute.scan.path) {
    return PageRouteBuilder<String>(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => BlocProvider<ScanPresenter>(
        create: (_) => ScanPresenter(),
        child: BlocListener<ScanPresenter, ScanViewModel>(
          listener: (BuildContext context, ScanViewModel viewModel) {
            if (viewModel is ScanSuccessState) {
              Navigator.pop(context, viewModel.barcode);
            }
          },
          child: const ScanView(),
        ),
      ),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
          FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  } else {
    return MaterialPageRoute<String>(builder: (_) => const HomeView());
  }
}

void _displayProductInfoOrHome({
  required BuildContext context,
  required String? barcode,
}) {
  if (barcode != null) {
    context.read<HomePresenter>().add(ShowProductInfoEvent(barcode));
  } else {
    context.read<HomePresenter>().add(const ShowHomeEvent());
  }
}
