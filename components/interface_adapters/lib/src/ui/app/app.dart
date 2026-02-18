import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/di/app_dependencies.dart';
import 'package:interface_adapters/src/ui/app/ethical_scanner_app.dart';

abstract interface class App extends StatelessWidget {
  const App({super.key});

  factory App.factory({
    required AppDependencies dependencies,
    required LocalizationDelegate localizationDelegate,
    required RouteFactory onGenerateRoute,
  }) {
    return EthicalScannerApp(
      dependencies: dependencies,
      localizationDelegate: localizationDelegate,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
