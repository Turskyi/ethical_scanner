import 'package:ethical_scanner/routes/app_route.dart';
import 'package:ethical_scanner/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Router', () {
    test('Generate Route - Home', () {
      // Arrange
      final RouteSettings settings = RouteSettings(name: AppRoute.home.path);

      // Act
      final Route<String> route = generateRoute(settings);

      // Assert
      expect(route is PageRouteBuilder<String>, true);
      // You can add more assertions based on your specific requirements
    });

    test('Generate Route - Scan', () {
      // Arrange
      final RouteSettings settings = RouteSettings(name: AppRoute.scan.path);

      // Act
      final Route<String> route = generateRoute(settings);

      // Assert
      expect(route is PageRouteBuilder<String>, true);
      // You can add more assertions based on your specific requirements
    });

    test('Generate Route - Unknown', () {
      // Arrange
      const RouteSettings settings = RouteSettings(name: 'unknown_route');

      // Act
      final Route<String> route = generateRoute(settings);

      // Assert
      expect(route is MaterialPageRoute<String>, true);
    });
  });
}
