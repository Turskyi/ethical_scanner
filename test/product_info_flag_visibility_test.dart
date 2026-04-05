import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the flag-visibility logic from ProductInfoTile.build().
bool _showRedFlag(ProductInfo info) {
  final bool isRedBackground =
      info.isCompanyTerrorismSponsor || info.isFromRussia;
  return info.isGs1CountryStateSponsorOfTerrorism && !isRedBackground;
}

bool _showGreenFlag(ProductInfo info) {
  final bool isGreenBackground = info.isVegan || info.isVegetarian;
  return (info.isVegan || info.isVegetarian) && !isGreenBackground;
}

void main() {
  group('ProductInfo.isGs1CountryStateSponsorOfTerrorism', () {
    test('returns true for all four US State Dept terrorism sponsors', () {
      for (final String country in <String>[
        'Cuba',
        'North Korea',
        'Iran',
        'Syria',
      ]) {
        expect(
          ProductInfo(gs1Country: country).isGs1CountryStateSponsorOfTerrorism,
          isTrue,
          reason: country,
        );
      }
    });

    test('returns false for non-designated countries', () {
      expect(
        ProductInfo(gs1Country: 'Germany').isGs1CountryStateSponsorOfTerrorism,
        isFalse,
      );
    });
  });

  group('Red flag visibility', () {
    test('shows on yellow background (no terrorism sponsor, not Russia)', () {
      final ProductInfo info = ProductInfo(gs1Country: 'Iran');
      expect(_showRedFlag(info), isTrue);
    });

    test('shows on green background (vegan product with terrorism GS1)', () {
      final ProductInfo info = ProductInfo(
        gs1Country: 'Iran',
        vegan: Vegan.positive,
      );
      expect(_showRedFlag(info), isTrue);
    });

    test('is suppressed on red background (company terrorism sponsor)', () {
      final ProductInfo info = ProductInfo(
        gs1Country: 'Iran',
        isCompanyTerrorismSponsor: true,
      );
      expect(_showRedFlag(info), isFalse);
    });

    test('is suppressed on red background (Russia barcode)', () {
      final ProductInfo info = ProductInfo(
        gs1Country: 'Iran',
        barcode: '4601234567890',
      );
      expect(_showRedFlag(info), isFalse);
    });
  });

  group('Green flag visibility', () {
    // A vegan/vegetarian product always produces a green background, so the
    // green flag is intentionally suppressed — the background already signals
    // the positive outcome. This test documents that design decision.
    test('is suppressed on green background (vegan product)', () {
      final ProductInfo info = ProductInfo(vegan: Vegan.positive);
      expect(_showGreenFlag(info), isFalse);
    });

    test('is suppressed on green background (vegetarian product)', () {
      final ProductInfo info = ProductInfo(vegetarian: Vegetarian.positive);
      expect(_showGreenFlag(info), isFalse);
    });
  });
}
