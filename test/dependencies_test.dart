import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:use_cases/use_cases.dart';

import 'mock_dependencies.dart';

void main() {
  group('Dependencies', () {
    late Dependencies dependencies;
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      dependencies = await MockDependencies.create();
    });
    test(
        'getPrecipitationStateUseCase returns instance of '
        'GetPrecipitationStateUseCase', () async {
      expect(
        dependencies.getPrecipitationStateUseCase,
        isA<GetPrecipitationStateUseCase>(),
      );
    });
    test('getLanguageUseCase returns instance of GetLanguageUseCase', () async {
      expect(
        dependencies.getLanguageUseCase,
        isA<GetLanguageUseCase>(),
      );
    });
    test(
        'savePrecipitationStateUseCas returns instance of '
        'SavePrecipitationStateUseCase', () async {
      expect(
        dependencies.savePrecipitationStateUseCase,
        isA<SavePrecipitationStateUseCase>(),
      );
    });
    test('getProductInfoUseCase should be GetProductInfoUseCase', () async {
      // Act
      final UseCase<Future<ProductInfo>, Barcode> useCase =
          dependencies.productInfoUseCase;
      // Assert
      expect(useCase, isA<GetProductInfoUseCase>());
    });
  });
}
