import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DependenciesScope', () {
    testWidgets('of method should retrieve dependencies',
        (WidgetTester tester) async {
      // Arrange
      Dependencies dependencies = Dependencies();
      DependenciesScope widget = DependenciesScope(
        dependencies: dependencies,
        child: const SizedBox(),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      final Dependencies retrievedDependencies =
          DependenciesScope.of(tester.element(find.byType(SizedBox)));
      expect(retrievedDependencies, equals(dependencies));
    });
  });
}
