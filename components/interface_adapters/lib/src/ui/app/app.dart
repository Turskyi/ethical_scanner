import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/app/ethical_scanner_app.dart';

abstract class App extends StatelessWidget {
  factory App(RouteFactory routeFactory) => EthicalScannerApp(
        routeFactory: routeFactory,
      );
}
