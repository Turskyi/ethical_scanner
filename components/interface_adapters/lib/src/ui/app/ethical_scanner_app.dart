import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/color/app_colors.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';

class EthicalScannerApp extends StatelessWidget implements App {
  const EthicalScannerApp({super.key, required this.routeFactory});

  /// {@macro flutter.widgets.widgetsApp.onGenerateRoute}
  final RouteFactory routeFactory;

  @override
  Widget build(BuildContext context) {
    return Resources(
      gradients: Gradients(),
      child: MaterialApp(
        title: translate('title'),
        onGenerateRoute: routeFactory,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primarySwatch),
          primarySwatch: AppColors.primarySwatch,
        ),
      ),
    );
  }
}
