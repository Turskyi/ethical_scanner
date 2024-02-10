import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalDataSourceImpl', () {
    test('getCountryFromBarcode should return the correct country', () {
      LocalDataSourceImpl localDataSource = LocalDataSourceImpl();

      // Test cases with known barcode prefixes and expected countries
      final Map<String, String> testCases = <String, String>{
        '0001234567890': 'United States and Canada',
        '0571234567890': 'United States',
        '0611234567890': 'United States',
        '0641234567890': 'Bhutan',
        '0861234567890': 'United States',
        '1251234567890': 'United States',
      };

      testCases.forEach((String barcode, String expectedCountry) {
        final String result = localDataSource.getCountryFromBarcode(barcode);
        expect(result, equals(expectedCountry));
      });
    });

    test('isEnglishBook should return true for English books', () {
      LocalDataSourceImpl localDataSource = LocalDataSourceImpl();

      // Test cases with known ISBN-13 barcodes for English books
      final List<String> testCases = <String>[
        '9781234567890',
        '9780123456789',
        '9789876543210',
      ];

      for (String barcode in testCases) {
        final bool result = localDataSource.isEnglishBook(barcode);
        expect(result, isTrue);
      }
    });

    test('isEnglishBook should return false for non-English books', () {
      LocalDataSourceImpl localDataSource = LocalDataSourceImpl();

      // Test cases with non-ISBN-13 barcodes or non-English books
      final List<String> testCases = <String>[
        '1234567890123', // Not ISBN-13
        '978123456789', // Not 13 digits
        '9791234567890', // Not English book
      ];

      for (String barcode in testCases) {
        final bool result = localDataSource.isEnglishBook(barcode);
        expect(result, isFalse);
      }
    });
  });
}
