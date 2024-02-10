import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/app/ethical_scanner_app.dart';

abstract interface class App extends StatelessWidget {
  const App({super.key});

  factory App.factory(RouteFactory routeFactory) => EthicalScannerApp(
    routeFactory: routeFactory,
  );
}
