import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:test/test.dart';
import 'package:use_cases/use_cases.dart';

void main() {
  group('Dependencies', () {
    test('getProductInfoUseCase should not be null', () {
      // Arrange
      Dependencies dependencies = Dependencies();

      // Act
      final UseCase<Future<ProductInfo>, Barcode> useCase =
          dependencies.productInfoUseCase;

      // Assert
      expect(useCase, isNotNull);
      expect(useCase, isA<UseCase<Future<ProductInfo>, String>>());
    });
  });
}
