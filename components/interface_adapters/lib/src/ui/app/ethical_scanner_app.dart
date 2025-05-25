import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class EthicalScannerApp extends StatelessWidget implements App {
  const EthicalScannerApp({super.key, required this.routeFactory});

  /// {@macro flutter.widgets.widgetsApp.onGenerateRoute}
  final RouteFactory routeFactory;

  @override
  Widget build(BuildContext context) {
    return Resources(
      colors: MaterialColors(),
      gradients: Gradients(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: translate('title'),
        onGenerateRoute: routeFactory,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: MaterialColors.primarySwatch,
          ),
          primarySwatch: MaterialColors.primarySwatch,
        ),
      ),
    );
  }
}
