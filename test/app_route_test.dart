import 'package:flutter_test/flutter_test.dart';
import 'package:interface_adapters/interface_adapters.dart' as route;
import 'package:path/path.dart' as path;

void main() {
  group('RouteExtension', () {
    test('path property should return the correct paths', () {
      // Arrange & Act
      const String homePath = route.kHomePath;
      const String scanPath = route.kScanPath;
      const String settingsPath = route.kSettingsPath;

      // Assert
      expect(homePath, '/');
      expect(scanPath, '/scan');
      expect(settingsPath, '/settings');
    });

    test('paths should be unique', () {
      // Arrange
      final List<String> paths = <String>[
        route.kHomePath,
        route.kScanPath,
        route.kSettingsPath,
      ];

      // Act
      final Set<String> uniquePaths = Set<String>.from(paths);

      // Assert
      expect(paths.length, uniquePaths.length);
    });

    test('paths should not be empty', () {
      // Arrange & Act & Assert
      expect(route.kHomePath.isNotEmpty, true);
      expect(route.kScanPath.isNotEmpty, true);
      expect(route.kSettingsPath.isNotEmpty, true);
    });

    test('paths should not contain consecutive slashes', () {
      // Arrange & Act & Assert
      expect(route.kHomePath.contains('//'), false);
      expect(route.kScanPath.contains('//'), false);
      expect(route.kSettingsPath.contains('//'), false);
    });

    test('paths should be valid', () {
      // Arrange
      const String homePath = route.kHomePath;
      const String scanPath = route.kScanPath;
      const String settingsPath = route.kSettingsPath;

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
