import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  group('RemoteDataSourceImpl', () {
    late RemoteDataSourceImpl remoteDataSource;

    setUp(() {
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'ethical_scanner',
      );

      OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
        OpenFoodFactsLanguage.ENGLISH,
      ];

      OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;

      // Initialize the RemoteDataSourceImpl
      remoteDataSource = const RemoteDataSourceImpl();
    });

    test('getProductInfoAsFuture returns ProductInfo on success', () async {
      // Arrange
      const String input = '0055577105436';
      const ProductInfo expectedResult = ProductInfo(
        barcode: input,
        country: 'Canada',
      );

      // Act
      final ProductInfo result = await remoteDataSource.getProductInfoAsFuture(
        input,
      );

      // Assert
      expect(result.country, equals(expectedResult.country));
      expect(result.barcode, equals(expectedResult.barcode));
    });
  });
}
