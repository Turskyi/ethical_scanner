import 'package:ethical_scanner/routes/routes.dart' as route;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('RouteExtension', () {
    test('path property should return the correct paths', () {
      // Arrange & Act
      const String homePath = route.homePath;
      const String scanPath = route.scanPath;
      const String settingsPath = route.settingsPath;

      // Assert
      expect(homePath, '/');
      expect(scanPath, '/scan');
      expect(settingsPath, '/settings');
    });

    test('paths should be unique', () {
      // Arrange
      final List<String> paths = <String>[
        route.homePath,
        route.scanPath,
        route.settingsPath,
      ];

      // Act
      final Set<String> uniquePaths = Set<String>.from(paths);

      // Assert
      expect(paths.length, uniquePaths.length);
    });

    test('paths should not be empty', () {
      // Arrange & Act & Assert
      expect(route.homePath.isNotEmpty, true);
      expect(route.scanPath.isNotEmpty, true);
      expect(route.settingsPath.isNotEmpty, true);
    });

    test('paths should not contain consecutive slashes', () {
      // Arrange & Act & Assert
      expect(route.homePath.contains('//'), false);
      expect(route.scanPath.contains('//'), false);
      expect(route.settingsPath.contains('//'), false);
    });

    test('paths should be valid', () {
      // Arrange
      const String homePath = route.homePath;
      const String scanPath = route.scanPath;
      const String settingsPath = route.settingsPath;

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
