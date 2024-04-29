import 'package:ethical_scanner/router/router.dart';
import 'package:ethical_scanner/router/routes.dart' as route;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Router', () {
    test('Generate Route - Home', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: route.homePath);

      // Act
      final Route<String> pageRoute = generateRoute(settings);

      // Assert
      expect(pageRoute is PageRouteBuilder<String>, true);
      // You can add more assertions based on your specific requirements
    });

    test('Generate Route - Scan', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: route.scanPath);

      // Act
      final Route<String> pageRoute = generateRoute(settings);

      // Assert
      expect(pageRoute is PageRouteBuilder<String>, true);
      // You can add more assertions based on your specific requirements
    });

    test('Generate Route - Unknown', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: 'unknown_route');

      // Act
      final Route<String> route = generateRoute(settings);

      // Assert
      expect(route is PageRouteBuilder<String>, true);
    });
  });
}
