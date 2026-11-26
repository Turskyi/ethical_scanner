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
      expect(
        CountryLocalizer.getLocalizedName(
          OpenFoodFactsCountry.USA,
          localeCode: 'en',
        ),
        'USA',
      );
    });

    test('returns correct English name for USA and acronyms', () {
      expect(CountryLocalizer.getEnglishName(OpenFoodFactsCountry.USA), 'USA');
      expect(
        CountryLocalizer.getEnglishName(OpenFoodFactsCountry.US_VIRGIN_ISLANDS),
        'US Virgin Islands',
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
          CountryLocalizer.findMatchingCountry('Украина'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('ru:украина'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('en:ukraine'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('ua'),
          OpenFoodFactsCountry.UKRAINE,
        );
        expect(
          CountryLocalizer.findMatchingCountry('USA'),
          OpenFoodFactsCountry.USA,
        );
        expect(
          CountryLocalizer.findMatchingCountry('Usa'),
          OpenFoodFactsCountry.USA,
        );
        expect(
          CountryLocalizer.findMatchingCountry('Нідерланди'),
          OpenFoodFactsCountry.NETHERLANDS,
        );
        expect(
          CountryLocalizer.findMatchingCountry('Россия'),
          OpenFoodFactsCountry.RUSSIA,
        );
        expect(
          CountryLocalizer.findMatchingCountry('invalid_country_xyz'),
          isNull,
        );
      },
    );

    test(
      'localizeOrigin translates free-text origins into target language',
      () {
        expect(
          CountryLocalizer.localizeOrigin('Украина', localeCode: 'en'),
          'Ukraine',
        );
        expect(
          CountryLocalizer.localizeOrigin('Украина', localeCode: 'uk'),
          'Україна',
        );
        expect(
          CountryLocalizer.localizeOrigin('en:ukraine', localeCode: 'en'),
          'Ukraine',
        );
        expect(
          CountryLocalizer.localizeOrigin('en:ukraine', localeCode: 'uk'),
          'Україна',
        );
        expect(
          CountryLocalizer.localizeOrigin(
            'Украина, Германия',
            localeCode: 'en',
          ),
          'Ukraine, Germany',
        );
        expect(CountryLocalizer.localizeOrigin('', localeCode: 'en'), '');
      },
    );
  });
}
