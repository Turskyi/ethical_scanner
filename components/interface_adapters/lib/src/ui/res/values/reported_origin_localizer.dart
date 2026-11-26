import 'package:entities/entities.dart';

/// Localizes country names in evidence-based reported origins.
abstract final class ReportedOriginLocalizer {
  const ReportedOriginLocalizer._();

  static const String _originsSeparator = ', ';
  static const String _regionSeparator = ' (';
  static const String _closingParenthesis = ')';
  static const String _englandRegionName = 'england';
  static const String _ukrainianEnglandRegionName = 'Англія';

  static const Map<String, String> _ukrainianRegionNames = <String, String>{
    _englandRegionName: _ukrainianEnglandRegionName,
  };

  /// Localizes recognized country names and keeps unrecognized details intact.
  static String getLocalizedName(
    String reportedOrigin, {
    required Language language,
  }) {
    if (language.isEnglish) {
      return reportedOrigin;
    } else {
      return reportedOrigin
          .split(_originsSeparator)
          .map(
            (String origin) =>
                _getLocalizedOrigin(origin: origin, language: language),
          )
          .join(_originsSeparator);
    }
  }

  static String _getLocalizedOrigin({
    required String origin,
    required Language language,
  }) {
    final IsoCountry? exactCountry = _findCountry(origin.trim());
    if (exactCountry != null) {
      return exactCountry.localizedName(language);
    } else {
      final int regionStartIndex = origin.indexOf(_regionSeparator);
      final bool hasRegion =
          regionStartIndex > 0 && origin.endsWith(_closingParenthesis);

      if (hasRegion) {
        final String countryName = origin.substring(0, regionStartIndex).trim();
        final IsoCountry? country = _findCountry(countryName);
        if (country != null) {
          final String regionName = origin
              .substring(
                regionStartIndex + _regionSeparator.length,
                origin.length - _closingParenthesis.length,
              )
              .trim();
          final String localizedRegion =
              _ukrainianRegionNames[regionName.toLowerCase()] ?? regionName;

          return '${country.localizedName(language)} ($localizedRegion)';
        } else {
          return origin;
        }
      } else {
        return origin;
      }
    }
  }

  static IsoCountry? _findCountry(String countryName) {
    final String normalizedName = countryName.toLowerCase();
    for (final IsoCountry country in IsoCountry.values) {
      if (country.englishName.toLowerCase() == normalizedName) {
        return country;
      }
    }
    return null;
  }
}
