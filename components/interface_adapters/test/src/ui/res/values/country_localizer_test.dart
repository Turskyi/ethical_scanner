import 'package:flutter_test/flutter_test.dart';
import 'package:interface_adapters/src/ui/res/values/country_localizer.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  group('CountryLocalizer', () {
    test('returns Ukrainian country names when locale is uk', () {
      expect(
        CountryLocalizer.getLocalizedName(
          OpenFoodFactsCountry.UKRAINE,
          localeCode: 'uk',
        ),
        'Україна',
      );
      expect(
        CountryLocalizer.getLocalizedName(
          OpenFoodFactsCountry.NETHERLANDS,
          localeCode: 'uk',
        ),
        'Нідерланди',
      );
      expect(
        CountryLocalizer.getLocalizedName(
          OpenFoodFactsCountry.GERMANY,
          localeCode: 'uk',
        ),
        'Німеччина',
      );
    });

    test('returns English country names when locale is en', () {
      expect(
        CountryLocalizer.getLocalizedName(
          OpenFoodFactsCountry.UKRAINE,
          localeCode: 'en',
        ),
        'Ukraine',
      );
      expect(
        CountryLocalizer.getLocalizedName(
          OpenFoodFactsCountry.NETHERLANDS,
          localeCode: 'en',
        ),
        'Netherlands',
      );
    });

    test('matches Ukrainian, English, offTag, and iso3Code queries', () {
      expect(
        CountryLocalizer.matches(
          OpenFoodFactsCountry.NETHERLANDS,
          'Нідер',
          localeCode: 'uk',
        ),
        isTrue,
      );
      expect(
        CountryLocalizer.matches(
          OpenFoodFactsCountry.NETHERLANDS,
          'nether',
          localeCode: 'uk',
        ),
        isTrue,
      );
      expect(
        CountryLocalizer.matches(
          OpenFoodFactsCountry.NETHERLANDS,
          'nl',
          localeCode: 'uk',
        ),
        isTrue,
      );
      expect(
        CountryLocalizer.matches(
          OpenFoodFactsCountry.NETHERLANDS,
          'NLD',
          localeCode: 'uk',
        ),
        isTrue,
      );
    });

    test(
      'findMatchingCountry matches country by Ukrainian or English name',
      () {
        expect(
          CountryLocalizer.findMatchingCountry('Україна'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('Ukraine'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('ua'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('Нідерланди'),
          OpenFoodFactsCountry.NETHERLANDS,
        );
        expect(
          CountryLocalizer.findMatchingCountry('invalid_country_xyz'),
          isNull,
        );
      },
    );
  });
}
