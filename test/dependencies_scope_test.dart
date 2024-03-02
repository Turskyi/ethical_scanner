import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_dependencies.dart';

void main() {
  group('DependenciesScope', () {
    late Dependencies dependencies;
    late DependenciesScope dependenciesScope;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      dependencies = await MockDependencies.create();
      dependenciesScope = DependenciesScope(
        dependencies: dependencies,
        child: const SizedBox(),
      );
    });

    testWidgets('of method should retrieve dependencies',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(dependenciesScope);

      // Assert
      final Dependencies retrievedDependencies =
          DependenciesScope.of(tester.element(find.byType(SizedBox)));

      expect(retrievedDependencies, equals(dependencies));
    });

    test('debugFillProperties adds expected properties', () {
      final DiagnosticPropertiesBuilder properties =
          DiagnosticPropertiesBuilder();

      dependenciesScope.debugFillProperties(properties);

      final DiagnosticsNode property = properties.properties
          .firstWhere((DiagnosticsNode p) => p.name == 'dependencies');
      expect(property.value, equals(dependencies));
    });
    test('updateShouldNotify returns false', () {
      expect(dependenciesScope.updateShouldNotify(dependenciesScope), isFalse);
    });
  });
}
