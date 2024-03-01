import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:use_cases/use_cases.dart';

import 'mock_dependencies.dart';

void main() {
  group('Dependencies', () {
    test('getProductInfoUseCase should be GetProductInfoUseCase', () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Arrange
      Dependencies dependencies = await MockDependencies.create();

      // Act
      final UseCase<Future<ProductInfo>, Barcode> useCase =
          dependencies.productInfoUseCase;
      // Assert
      expect(useCase, isA<GetProductInfoUseCase>());
    });
  });
}
