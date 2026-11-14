import 'package:openfoodfacts/openfoodfacts.dart';

/// Provides localization and multi-language search support for
/// [OpenFoodFactsCountry].
abstract final class CountryLocalizer {
  const CountryLocalizer._();

  /// Language code for Ukrainian.
  static const String ukrainianLanguageCode = 'uk';

  /// Returns the localized country name based on [localeCode].
  ///
  /// Defaults to Ukrainian if [localeCode] starts with 'uk',
  /// otherwise returns formatted English name.
  static String getLocalizedName(
    OpenFoodFactsCountry country, {
    String? localeCode,
  }) {
    if (localeCode != null && localeCode.startsWith(ukrainianLanguageCode)) {
      final String? ukrainianName = _ukrainianNames[country];
      if (ukrainianName != null && ukrainianName.isNotEmpty) {
        return ukrainianName;
      } else {
        return getEnglishName(country);
      }
    } else {
      return getEnglishName(country);
    }
  }

  /// Returns the English title-case name for [country].
  static String getEnglishName(OpenFoodFactsCountry country) {
    final String name = country.name.replaceAll('_', ' ').toLowerCase();
    return name
        .split(' ')
        .map((String word) {
          if (word.isEmpty) {
            return '';
          } else {
            return word[0].toUpperCase() + word.substring(1);
          }
        })
        .join(' ');
  }

  /// Checks if [country] matches [query] in Ukrainian name, English name,
  /// ISO code, or OFF tag.
  static bool matches(
    OpenFoodFactsCountry country,
    String query, {
    String? localeCode,
  }) {
    final String normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    } else {
      final String ukrainianName =
          _ukrainianNames[country]?.toLowerCase() ?? '';
      final String englishName = getEnglishName(country).toLowerCase();
      final String offTag = country.offTag.toLowerCase();
      final String iso3Code = country.iso3Code.toLowerCase();

      return ukrainianName.contains(normalizedQuery) ||
          englishName.contains(normalizedQuery) ||
          offTag == normalizedQuery ||
          iso3Code == normalizedQuery;
    }
  }

  /// Finds an [OpenFoodFactsCountry] matching [input] string.
  ///
  /// Matches against English name, Ukrainian name, offTag, or iso3Code.
  static OpenFoodFactsCountry? findMatchingCountry(String input) {
    final String normalizedInput = input.trim().toLowerCase();
    if (normalizedInput.isEmpty) {
      return null;
    } else {
      return OpenFoodFactsCountry.values.where((OpenFoodFactsCountry country) {
        final String ukrainianName =
            _ukrainianNames[country]?.toLowerCase() ?? '';
        final String englishName = getEnglishName(country).toLowerCase();
        final String offTag = country.offTag.toLowerCase();
        final String iso3Code = country.iso3Code.toLowerCase();

        return ukrainianName == normalizedInput ||
            englishName == normalizedInput ||
            offTag == normalizedInput ||
            iso3Code == normalizedInput;
      }).firstOrNull;
    }
  }

  static const Map<OpenFoodFactsCountry, String> _ukrainianNames =
      <OpenFoodFactsCountry, String>{
        OpenFoodFactsCountry.ANDORRA: 'Андорра',
        OpenFoodFactsCountry.UNITED_ARAB_EMIRATES: "Об'єднані Арабські Емірати",
        OpenFoodFactsCountry.AFGHANISTAN: 'Афганістан',
        OpenFoodFactsCountry.ANTIGUA_AND_BARBUDA: 'Антигуа і Барбуда',
        OpenFoodFactsCountry.ANGUILLA: 'Анґілья',
        OpenFoodFactsCountry.ALBANIA: 'Албанія',
        OpenFoodFactsCountry.ARMENIA: 'Вірменія',
        OpenFoodFactsCountry.ANGOLA: 'Ангола',
        OpenFoodFactsCountry.ANTARCTICA: 'Антарктида',
        OpenFoodFactsCountry.ARGENTINA: 'Аргентина',
        OpenFoodFactsCountry.AMERICAN_SAMOA: 'Американське Самоа',
        OpenFoodFactsCountry.AUSTRIA: 'Австрія',
        OpenFoodFactsCountry.AUSTRALIA: 'Австралія',
        OpenFoodFactsCountry.ARUBA: 'Аруба',
        OpenFoodFactsCountry.ALAND_ISLANDS: 'Аландські острови',
        OpenFoodFactsCountry.AZERBAIJAN: 'Азербайджан',
        OpenFoodFactsCountry.BOSNIA_AND_HERZEGOVINA: 'Боснія і Герцеговина',
        OpenFoodFactsCountry.BARBADOS: 'Барбадос',
        OpenFoodFactsCountry.BANGLADESH: 'Бангладеш',
        OpenFoodFactsCountry.BELGIUM: 'Бельгія',
        OpenFoodFactsCountry.BURKINA_FASO: 'Буркіна-Фасо',
        OpenFoodFactsCountry.BULGARIA: 'Болгарія',
        OpenFoodFactsCountry.BAHRAIN: 'Бахрейн',
        OpenFoodFactsCountry.BURUNDI: 'Бурунді',
        OpenFoodFactsCountry.BENIN: 'Бенін',
        OpenFoodFactsCountry.SAINT_BARTHELEMY: 'Сен-Бартелемі',
        OpenFoodFactsCountry.BERMUDA: 'Бермудські острови',
        OpenFoodFactsCountry.BRUNEI_DARUSSALAM: 'Бруней',
        OpenFoodFactsCountry.BOLIVIA: 'Болівія',
        OpenFoodFactsCountry.BONAIRE: 'Бонайре, Сінт-Естатіус і Саба',
        OpenFoodFactsCountry.BRAZIL: 'Бразилія',
        OpenFoodFactsCountry.BAHAMAS: 'Багамські острови',
        OpenFoodFactsCountry.BHUTAN: 'Бутан',
        OpenFoodFactsCountry.BOUVET_ISLAND: 'Острів Буве',
        OpenFoodFactsCountry.BOTSWANA: 'Ботсвана',
        OpenFoodFactsCountry.BELARUS: 'Білорусь',
        OpenFoodFactsCountry.BELIZE: 'Беліз',
        OpenFoodFactsCountry.CANADA: 'Канада',
        OpenFoodFactsCountry.COCOS_ISLANDS: 'Кокосові острови',
        OpenFoodFactsCountry.DEMOCRATIC_REPUBLIC_OF_THE_CONGO:
            'Демократична Республіка Конго',
        OpenFoodFactsCountry.CENTRAL_AFRICAN_REPUBLIC:
            'Центральноафриканська Республіка',
        OpenFoodFactsCountry.CONGO: 'Республіка Конго',
        OpenFoodFactsCountry.SWITZERLAND: 'Швейцарія',
        OpenFoodFactsCountry.COTE_D_IVOIRE: "Кот-д'Івуар",
        OpenFoodFactsCountry.COOK_ISLANDS: 'Острови Кука',
        OpenFoodFactsCountry.CHILE: 'Чилі',
        OpenFoodFactsCountry.CAMEROON: 'Камерун',
        OpenFoodFactsCountry.CHINA: 'Китай',
        OpenFoodFactsCountry.COLOMBIA: 'Колумбія',
        OpenFoodFactsCountry.COSTA_RICA: 'Коста-Рика',
        OpenFoodFactsCountry.CUBA: 'Куба',
        OpenFoodFactsCountry.CABO_VERDE: 'Кабо-Верде',
        OpenFoodFactsCountry.CURACAO: 'Кюрасао',
        OpenFoodFactsCountry.CHRISTMAS_ISLAND: 'Острів Різдва',
        OpenFoodFactsCountry.CYPRUS: 'Кіпр',
        OpenFoodFactsCountry.CZECHIA: 'Чехія',
        OpenFoodFactsCountry.GERMANY: 'Німеччина',
        OpenFoodFactsCountry.DJIBOUTI: 'Джибуті',
        OpenFoodFactsCountry.DENMARK: 'Данія',
        OpenFoodFactsCountry.DOMINICA: 'Домініка',
        OpenFoodFactsCountry.DOMINICAN_REPUBLIC: 'Домініканська Республіка',
        OpenFoodFactsCountry.ALGERIA: 'Алжир',
        OpenFoodFactsCountry.ECUADOR: 'Еквадор',
        OpenFoodFactsCountry.ESTONIA: 'Естонія',
        OpenFoodFactsCountry.EGYPT: 'Єгипет',
        OpenFoodFactsCountry.WESTERN_SAHARA: 'Західна Сахара',
        OpenFoodFactsCountry.ERITREA: 'Еритрея',
        OpenFoodFactsCountry.SPAIN: 'Іспанія',
        OpenFoodFactsCountry.ETHIOPIA: 'Ефіопія',
        OpenFoodFactsCountry.FINLAND: 'Фінляндія',
        OpenFoodFactsCountry.FIJI: 'Фіджі',
        OpenFoodFactsCountry.FALKLAND_ISLANDS: 'Фолклендські острови',
        OpenFoodFactsCountry.MICRONESIA: 'Мікронезія',
        OpenFoodFactsCountry.FAROE_ISLANDS: 'Фарерські острови',
        OpenFoodFactsCountry.FRANCE: 'Франція',
        OpenFoodFactsCountry.GABON: 'Габон',
        OpenFoodFactsCountry.UNITED_KINGDOM: 'Велика Британія',
        OpenFoodFactsCountry.GRENADA: 'Гренада',
        OpenFoodFactsCountry.GEORGIA: 'Грузія',
        OpenFoodFactsCountry.FRENCH_GUIANA: 'Французька Гвіана',
        OpenFoodFactsCountry.GUERNSEY: 'Гернсі',
        OpenFoodFactsCountry.GHANA: 'Гана',
        OpenFoodFactsCountry.GIBRALTAR: 'Гібралтар',
        OpenFoodFactsCountry.GREENLAND: 'Ґренландія',
        OpenFoodFactsCountry.GAMBIA: 'Гамбія',
        OpenFoodFactsCountry.GUINEA: 'Гвінея',
        OpenFoodFactsCountry.GUADELOUPE: 'Гваделупа',
        OpenFoodFactsCountry.EQUATORIAL_GUINEA: 'Екваторіальна Гвінея',
        OpenFoodFactsCountry.GREECE: 'Греція',
        OpenFoodFactsCountry.SOUTH_GEORGIA:
            'Південна Джорджія та Південні Сандвічеві острови',
        OpenFoodFactsCountry.GUATEMALA: 'Гватемала',
        OpenFoodFactsCountry.GUAM: 'Ґуам',
        OpenFoodFactsCountry.GUINEA_BISSAU: 'Гвінея-Бісау',
        OpenFoodFactsCountry.GUYANA: 'Гайана',
        OpenFoodFactsCountry.HONG_KONG: 'Гонконг',
        OpenFoodFactsCountry.HEARD_ISLAND: 'Острів Герд і острови Макдональд',
        OpenFoodFactsCountry.HONDURAS: 'Гондурас',
        OpenFoodFactsCountry.CROATIA: 'Хорватія',
        OpenFoodFactsCountry.HAITI: 'Гаїті',
        OpenFoodFactsCountry.HUNGARY: 'Угорщина',
        OpenFoodFactsCountry.INDONESIA: 'Індонезія',
        OpenFoodFactsCountry.IRELAND: 'Ірландія',
        OpenFoodFactsCountry.ISRAEL: 'Ізраїль',
        OpenFoodFactsCountry.ISLE_OF_MAN: 'Острів Мен',
        OpenFoodFactsCountry.INDIA: 'Індія',
        OpenFoodFactsCountry.BRITISH_INDIAN_OCEAN_TERRITORY:
            'Британська територія в Індійському океані',
        OpenFoodFactsCountry.IRAQ: 'Ірак',
        OpenFoodFactsCountry.IRAN: 'Іран',
        OpenFoodFactsCountry.ICELAND: 'Ісландія',
        OpenFoodFactsCountry.ITALY: 'Італія',
        OpenFoodFactsCountry.JERSEY: 'Джерсі',
        OpenFoodFactsCountry.JAMAICA: 'Ямайка',
        OpenFoodFactsCountry.JORDAN: 'Йорданія',
        OpenFoodFactsCountry.JAPAN: 'Японія',
        OpenFoodFactsCountry.KENYA: 'Кенія',
        OpenFoodFactsCountry.KYRGYZSTAN: 'Киргизстан',
        OpenFoodFactsCountry.CAMBODIA: 'Камбоджа',
        OpenFoodFactsCountry.KIRIBATI: 'Кірибаті',
        OpenFoodFactsCountry.COMOROS: 'Коморські Острови',
        OpenFoodFactsCountry.SAINT_KITTS_AND_NEVIS: 'Сент-Кіттс і Невіс',
        OpenFoodFactsCountry.NORTH_KOREA: 'Північна Корея',
        OpenFoodFactsCountry.SOUTH_KOREA: 'Південна Корея',
        OpenFoodFactsCountry.KUWAIT: 'Кувейт',
        OpenFoodFactsCountry.CAYMAN_ISLANDS: 'Кайманові острови',
        OpenFoodFactsCountry.KAZAKHSTAN: 'Казахстан',
        OpenFoodFactsCountry.LAOS: 'Лаос',
        OpenFoodFactsCountry.LEBANON: 'Ліван',
        OpenFoodFactsCountry.SAINT_LUCIA: 'Сент-Люсія',
        OpenFoodFactsCountry.LIECHTENSTEIN: 'Ліхтенштейн',
        OpenFoodFactsCountry.SRI_LANKA: 'Шрі-Ланка',
        OpenFoodFactsCountry.LIBERIA: 'Ліберія',
        OpenFoodFactsCountry.LESOTHO: 'Лесото',
        OpenFoodFactsCountry.LITHUANIA: 'Литва',
        OpenFoodFactsCountry.LUXEMBOURG: 'Люксембург',
        OpenFoodFactsCountry.LATVIA: 'Латвія',
        OpenFoodFactsCountry.LIBYA: 'Лівія',
        OpenFoodFactsCountry.MOROCCO: 'Марокко',
        OpenFoodFactsCountry.MONACO: 'Монако',
        OpenFoodFactsCountry.MOLDOVA: 'Молдова',
        OpenFoodFactsCountry.MONTENEGRO: 'Чорногорія',
        OpenFoodFactsCountry.SAINT_MARTIN: 'Сен-Мартен',
        OpenFoodFactsCountry.MADAGASCAR: 'Мадагаскар',
        OpenFoodFactsCountry.MARSHALL_ISLANDS: 'Маршаллові Острови',
        OpenFoodFactsCountry.NORTH_MACEDONIA: 'Північна Македонія',
        OpenFoodFactsCountry.MALI: 'Малі',
        OpenFoodFactsCountry.MYANMAR: "М'янма",
        OpenFoodFactsCountry.MONGOLIA: 'Монголія',
        OpenFoodFactsCountry.MACAO: 'Макао',
        OpenFoodFactsCountry.NORTHERN_MARIANA_ISLANDS:
            'Північні Маріанські острови',
        OpenFoodFactsCountry.MARTINIQUE: 'Мартиніка',
        OpenFoodFactsCountry.MAURITANIA: 'Мавританія',
        OpenFoodFactsCountry.MONTSERRAT: 'Монтсеррат',
        OpenFoodFactsCountry.MALTA: 'Мальта',
        OpenFoodFactsCountry.MAURITIUS: 'Маврикій',
        OpenFoodFactsCountry.MALDIVES: 'Мальдіви',
        OpenFoodFactsCountry.MALAWI: 'Малаві',
        OpenFoodFactsCountry.MEXICO: 'Мексика',
        OpenFoodFactsCountry.MALAYSIA: 'Малайзія',
        OpenFoodFactsCountry.MOZAMBIQUE: 'Мозамбік',
        OpenFoodFactsCountry.NAMIBIA: 'Намібія',
        OpenFoodFactsCountry.NEW_CALEDONIA: 'Нова Каледонія',
        OpenFoodFactsCountry.NIGER: 'Нігер',
        OpenFoodFactsCountry.NORFOLK_ISLAND: 'Острів Норфолк',
        OpenFoodFactsCountry.NIGERIA: 'Нігерія',
        OpenFoodFactsCountry.NICARAGUA: 'Нікарагуа',
        OpenFoodFactsCountry.NETHERLANDS: 'Нідерланди',
        OpenFoodFactsCountry.NORWAY: 'Норвегія',
        OpenFoodFactsCountry.NEPAL: 'Непал',
        OpenFoodFactsCountry.NAURU: 'Науру',
        OpenFoodFactsCountry.NIUE: 'Ніуе',
        OpenFoodFactsCountry.NEW_ZEALAND: 'Нова Зеландія',
        OpenFoodFactsCountry.OMAN: 'Оман',
        OpenFoodFactsCountry.PANAMA: 'Панама',
        OpenFoodFactsCountry.PERU: 'Перу',
        OpenFoodFactsCountry.FRENCH_POLYNESIA: 'Французька Полінезія',
        OpenFoodFactsCountry.PAPUA_NEW_GUINEA: 'Папуа-Нова Гвінея',
        OpenFoodFactsCountry.PHILIPPINES: 'Філіппіни',
        OpenFoodFactsCountry.PAKISTAN: 'Пакистан',
        OpenFoodFactsCountry.POLAND: 'Польща',
        OpenFoodFactsCountry.SAINT_PIERRE_AND_MIQUELON: "Сен-П'єр і Мікелон",
        OpenFoodFactsCountry.PITCAIRN: 'Острови Піткерн',
        OpenFoodFactsCountry.PUERTO_RICO: 'Пуерто-Рико',
        OpenFoodFactsCountry.PALESTINE: 'Палестина',
        OpenFoodFactsCountry.PORTUGAL: 'Португалія',
        OpenFoodFactsCountry.PALAU: 'Палау',
        OpenFoodFactsCountry.PARAGUAY: 'Парагвай',
        OpenFoodFactsCountry.QATAR: 'Катар',
        OpenFoodFactsCountry.REUNION: 'Реюньйон',
        OpenFoodFactsCountry.ROMANIA: 'Румунія',
        OpenFoodFactsCountry.SERBIA: 'Сербія',
        OpenFoodFactsCountry.RUSSIA: 'Росія',
        OpenFoodFactsCountry.RWANDA: 'Руанда',
        OpenFoodFactsCountry.SAUDI_ARABIA: 'Саудівська Аравія',
        OpenFoodFactsCountry.SOLOMON_ISLANDS: 'Соломонові Острови',
        OpenFoodFactsCountry.SEYCHELLES: 'Сейшельські Острови',
        OpenFoodFactsCountry.SUDAN: 'Судан',
        OpenFoodFactsCountry.SWEDEN: 'Швеція',
        OpenFoodFactsCountry.SINGAPORE: 'Сінгапур',
        OpenFoodFactsCountry.SAINT_HELENA: 'Острів Святої Єлени',
        OpenFoodFactsCountry.SLOVENIA: 'Словенія',
        OpenFoodFactsCountry.SVALBARD_AND_JAN_MAYEN: 'Свальбард і Ян-Маєн',
        OpenFoodFactsCountry.SLOVAKIA: 'Словаччина',
        OpenFoodFactsCountry.SIERRA_LEONE: 'Сьєрра-Леоне',
        OpenFoodFactsCountry.SAN_MARINO: 'Сан-Марино',
        OpenFoodFactsCountry.SENEGAL: 'Сенегал',
        OpenFoodFactsCountry.SOMALIA: 'Сомалі',
        OpenFoodFactsCountry.SURINAME: 'Суринам',
        OpenFoodFactsCountry.SOUTH_SUDAN: 'Південний Судан',
        OpenFoodFactsCountry.SAO_TOME_AND_PRINCIPE: 'Сан-Томе і Принсіпі',
        OpenFoodFactsCountry.EL_SALVADOR: 'Сальвадор',
        OpenFoodFactsCountry.SINT_MAARTEN: 'Сінт-Мартен',
        OpenFoodFactsCountry.SYRIA: 'Сирія',
        OpenFoodFactsCountry.ESWATINI: 'Есватіні',
        OpenFoodFactsCountry.TURKS_AND_CAICOS_ISLANDS: 'Теркс і Кайкос',
        OpenFoodFactsCountry.CHAD: 'Чад',
        OpenFoodFactsCountry.FRENCH_SOUTHERN_TERRITORIES:
            'Французькі Південні і Антарктичні Території',
        OpenFoodFactsCountry.TOGO: 'Того',
        OpenFoodFactsCountry.THAILAND: 'Таїланд',
        OpenFoodFactsCountry.TAJIKISTAN: 'Таджикистан',
        OpenFoodFactsCountry.TOKELAU: 'Токелау',
        OpenFoodFactsCountry.TIMOR_LESTE: 'Східний Тимор',
        OpenFoodFactsCountry.TURKMENISTAN: 'Туркменістан',
        OpenFoodFactsCountry.TUNISIA: 'Туніс',
        OpenFoodFactsCountry.TONGA: 'Тонга',
        OpenFoodFactsCountry.TURKEY: 'Туреччина',
        OpenFoodFactsCountry.TRINIDAD_AND_TOBAGO: 'Тринідад і Тобаго',
        OpenFoodFactsCountry.TUVALU: 'Тувалу',
        OpenFoodFactsCountry.TAIWAN: 'Тайвань',
        OpenFoodFactsCountry.TANZANIA: 'Танзанія',
        OpenFoodFactsCountry.UKRAINE: 'Україна',
        OpenFoodFactsCountry.UGANDA: 'Уганда',
        OpenFoodFactsCountry.UNITED_STATES_MINOR_OUTLYING_ISLANDS:
            'Малі Віддалені Острови США',
        OpenFoodFactsCountry.USA: 'США',
        OpenFoodFactsCountry.URUGUAY: 'Уругвай',
        OpenFoodFactsCountry.UZBEKISTAN: 'Узбекистан',
        OpenFoodFactsCountry.HOLY_SEE: 'Ватикан',
        OpenFoodFactsCountry.SAINT_VINCENT_AND_THE_GRENADINES:
            'Сент-Вінсент і Гренадини',
        OpenFoodFactsCountry.VENEZUELA: 'Венесуела',
        OpenFoodFactsCountry.BRITISH_VIRGIN_ISLANDS:
            'Британські Віргінські острови',
        OpenFoodFactsCountry.US_VIRGIN_ISLANDS: 'Віргінські острови США',
        OpenFoodFactsCountry.VIET_NAM: "В'єтнам",
        OpenFoodFactsCountry.VANUATU: 'Вануату',
        OpenFoodFactsCountry.WALLIS_AND_FUTUNA: 'Уолліс і Футуна',
        OpenFoodFactsCountry.SAMOA: 'Самоа',
        OpenFoodFactsCountry.YEMEN: 'Ємен',
        OpenFoodFactsCountry.MAYOTTE: 'Майотта',
        OpenFoodFactsCountry.SOUTH_AFRICA: 'Південно-Африканська Республіка',
        OpenFoodFactsCountry.ZAMBIA: 'Замбія',
        OpenFoodFactsCountry.ZIMBABWE: 'Зімбабве',
      };
}
