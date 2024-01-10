import 'package:ethical_scanner/routes/app_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('RouteExtension', () {
    test('path property should return the correct paths', () {
      // Arrange & Act
      final String homePath = AppRoute.home.path;
      final String scanPath = AppRoute.scan.path;
      final String settingsPath = AppRoute.settings.path;

      // Assert
      expect(homePath, '/');
      expect(scanPath, '/scan');
      expect(settingsPath, '/settings');
    });

    test('paths should be unique', () {
      // Arrange
      final List<String> paths = <String>[
        AppRoute.home.path,
        AppRoute.scan.path,
        AppRoute.settings.path,
      ];

      // Act
      final Set<String> uniquePaths = Set<String>.from(paths);

      // Assert
      expect(paths.length, uniquePaths.length);
    });

    test('paths should not be empty', () {
      // Arrange & Act & Assert
      expect(AppRoute.home.path.isNotEmpty, true);
      expect(AppRoute.scan.path.isNotEmpty, true);
      expect(AppRoute.settings.path.isNotEmpty, true);
    });

    test('paths should not contain consecutive slashes', () {
      // Arrange & Act & Assert
      expect(AppRoute.home.path.contains('//'), false);
      expect(AppRoute.scan.path.contains('//'), false);
      expect(AppRoute.settings.path.contains('//'), false);
    });

    test('paths should be valid', () {
      // Arrange
      final String homePath = AppRoute.home.path;
      final String scanPath = AppRoute.scan.path;
      final String settingsPath = AppRoute.settings.path;

// Act
      final bool isHomePathValid = path.fromUri(homePath) != '';
      final bool isScanPathValid = path.fromUri(scanPath) != '';
      final bool isSettingsPathValid = path.fromUri(settingsPath) != '';

// Assert
      expect(isHomePathValid, isTrue);
      expect(isScanPathValid, isTrue);
      expect(isSettingsPathValid, isTrue);
    });
  });
}
