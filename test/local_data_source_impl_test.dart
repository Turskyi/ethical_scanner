import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_local_data_source_impl.dart';

void main() {
  group('LocalDataSourceImpl', () {
    late MockLocalDataSourceImpl localDataSource;
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      // await MockLocalDataSourceImpl().init();
      localDataSource = MockLocalDataSourceImpl();
    });

    test('getCountryFromBarcode should return the correct country', () {
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

    test('savePrecipitationState should save and retrieve precipitation state',
        () async {
      // Arrange
      const bool isPrecipitationFalling = true;

      // Act
      await localDataSource.savePrecipitationState(isPrecipitationFalling);
      final bool result = localDataSource.getPrecipitationState();

      // Assert
      expect(result, equals(isPrecipitationFalling));
    });

    test('saveSoundPreference should save and retrieve sound preference',
        () async {
      // Arrange
      const bool isSoundOn = true;

      // Act
      await localDataSource.saveSoundPreference(isSoundOn);
      final bool result = localDataSource.getSoundPreference();

      // Assert
      expect(result, equals(isSoundOn));
    });

    test('saveLanguageIsoCode should save and retrieve language ISO code',
        () async {
      // Arrange
      const String languageIsoCode = 'mock';

      // Act
      await localDataSource.saveLanguageIsoCode(languageIsoCode);
      final String result = localDataSource.getLanguageIsoCode();

      // Assert
      expect(result, equals(languageIsoCode));
    });

    test('getLanguageIsoCode should return platform language if not saved',
        () async {
      // Arrange
      const String platformLanguage = 'mock';

      // Act
      String result = localDataSource.getLanguageIsoCode();

      // Assert
      expect(result, equals(platformLanguage));
    });
  });
}
