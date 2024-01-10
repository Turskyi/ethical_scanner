import 'package:ethical_scanner/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContextExtension', () {
    testWidgets('maybeFindInheritedWidget should return null if not found',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const SizedBox());

      // Act
      final MyInheritedWidget? result = tester
          .element(find.byType(SizedBox))
          .maybeFindInheritedWidget<MyInheritedWidget>();

      // Assert
      expect(result, isNull);
    });

    testWidgets('maybeFindInheritedWidget should return the widget if found',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MyInheritedWidget(
          child: SizedBox(),
        ),
      );

      // Act
      final MyInheritedWidget? result = tester
          .element(find.byType(SizedBox))
          .maybeFindInheritedWidget<MyInheritedWidget>();

      // Assert
      expect(result, isNotNull);
    });

    testWidgets('findInheritedWidgetOrThrow should throw if not found',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const SizedBox());

      // Act and Assert
      expect(
        () => tester
            .element(find.byType(SizedBox))
            .findInheritedWidgetOrThrow<MyInheritedWidget>(),
        throwsA(isA<ArgumentError>()),
      );
    });

    testWidgets('findInheritedWidgetOrThrow should return the widget if found',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MyInheritedWidget(
          child: SizedBox(),
        ),
      );

      // Act
      final MyInheritedWidget result = tester
          .element(find.byType(SizedBox))
          .findInheritedWidgetOrThrow<MyInheritedWidget>();

      // Assert
      expect(result, isNotNull);
    });

    testWidgets('inheritFrom should throw if not found',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const SizedBox());

      // Act and Assert
      expect(
        () => tester
            .element(find.byType(SizedBox))
            .inheritFrom<String, MyInheritedModel>(),
        throwsA(isA<ArgumentError>()),
      );
    });

    testWidgets('inheritFrom should return the model if found',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MyInheritedModel(
          child: SizedBox(),
        ),
      );

      // Act
      final MyInheritedModel result = tester
          .element(find.byType(SizedBox))
          .inheritFrom<String, MyInheritedModel>();

      // Assert
      expect(result, isNotNull);
    });
  });
}

class MyInheritedWidget extends InheritedWidget {
  const MyInheritedWidget({super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyInheritedModel extends InheritedModel<String> {
  const MyInheritedModel({super.key, required super.child});

  @override
  bool updateShouldNotifyDependent(
    covariant MyInheritedModel oldWidget,
    Set<String> dependencies,
  ) {
    return false;
  }

  @override
  bool updateShouldNotify(covariant InheritedModel<String> oldWidget) {
    return false;
  }
}
