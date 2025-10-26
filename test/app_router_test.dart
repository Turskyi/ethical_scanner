import 'package:entities/entities.dart';
import 'package:ethical_scanner/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interface_adapters/interface_adapters.dart' as route;

void main() {
  group('App Router', () {
    test('Generate Route - Home', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: route.kHomePath);

      final AppRouter appRouter = AppRouter(savedLanguage: Language.en);

      // Act
      final Route<Object> pageRoute = appRouter.generateRoute(settings);

      // Assert
      expect(pageRoute is PageRouteBuilder<String>, true);
      // You can add more assertions based on your specific requirements
    });

    test('Generate Route - Scan', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: route.kScanPath);

      final AppRouter appRouter = AppRouter(savedLanguage: Language.en);

      // Act
      final Route<Object> pageRoute = appRouter.generateRoute(settings);

      // Assert
      expect(pageRoute is PageRouteBuilder<String>, true);
      // You can add more assertions based on your specific requirements
    });

    test('Generate Route - Unknown', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: 'unknown_route');

      final AppRouter appRouter = AppRouter(savedLanguage: Language.en);

      // Act
      final Route<Object> route = appRouter.generateRoute(settings);

      // Assert
      expect(route is PageRouteBuilder<String>, true);
    });
  });
}
