import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'investor.dart';
import 'logo.dart';

part 'fields.g.dart';

@JsonSerializable()
class Fields {
  const Fields({
    required this.name,
    this.brands = '',
    this.action,
    this.logo,
    this.status,
    this.exception,
    this.country,
    this.websiteUrl,
    this.instagram,
    this.twitter,
    this.sector,
    this.ticker,
    this.notes,
    this.marketCap,
    this.currency,
    this.industry,
    this.description,
    this.investors,
    this.stockPrice,
    this.facebook,
    this.linkToAnnouncement,
    this.cusip,
    this.tempLogo,
    this.lastModified,
    this.marketCapStd,
  });

  factory Fields.fromJson(Map<String, dynamic> json) {
    return _$FieldsFromJson(json);
  }

  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Brands')
  final String brands;
  @JsonKey(name: 'Action')
  final String? action;
  @JsonKey(name: 'Logo')
  final List<Logo>? logo;
  @JsonKey(name: 'Status')
  final String? status;
  @JsonKey(name: 'Exception')
  final String? exception;
  @JsonKey(name: 'Country')
  final String? country;
  @JsonKey(name: 'Website URL')
  final String? websiteUrl;
  @JsonKey(name: 'Instagram')
  final String? instagram;
  @JsonKey(name: 'Twitter')
  final String? twitter;
  @JsonKey(name: 'Sector')
  final String? sector;
  @JsonKey(name: 'Ticker')
  final String? ticker;
  @JsonKey(name: 'Notes')
  final String? notes;
  @JsonKey(name: 'Market Cap')
  final int? marketCap;
  @JsonKey(name: 'Currency')
  final String? currency;
  @JsonKey(name: 'Industry')
  final String? industry;
  @JsonKey(name: 'Description')
  final String? description;
  @JsonKey(name: 'Investors')
  final List<Investor>? investors;
  @JsonKey(name: 'Stock Price')
  final double? stockPrice;
  @JsonKey(name: 'Facebook')
  final String? facebook;
  @JsonKey(name: 'Link to Announcement')
  final String? linkToAnnouncement;
  @JsonKey(name: 'CUSIP')
  final String? cusip;
  @JsonKey(name: 'Temp Logo')
  final String? tempLogo;
  @JsonKey(name: 'Last Modified')
  final DateTime? lastModified;
  @JsonKey(name: 'Market Cap (Std)')
  final double? marketCapStd;

  @override
  String toString() {
    return 'Fields(name: $name, brands: $brands, action: $action, logo: $logo, '
        'status: $status, '
        'exception: $exception, country: $country, websiteUrl: $websiteUrl, '
        'instagram: $instagram, twitter: $twitter, sector: $sector, '
        'ticker: $ticker, notes: $notes, marketCap: $marketCap, '
        'currency: $currency, industry: $industry, description: $description, '
        'investors: $investors, stockPrice: $stockPrice, facebook: $facebook, '
        'linkToAnnouncement: $linkToAnnouncement, cusip: $cusip, '
        'tempLogo: $tempLogo, lastModified: $lastModified, '
        'marketCapStd: $marketCapStd)';
  }

  Map<String, dynamic> toJson() => _$FieldsToJson(this);

  Fields copyWith({
    String? name,
    String? brands,
    String? action,
    List<Logo>? logo,
    String? status,
    String? exception,
    String? country,
    String? websiteUrl,
    String? instagram,
    String? twitter,
    String? sector,
    String? ticker,
    String? notes,
    int? marketCap,
    String? currency,
    String? industry,
    String? description,
    List<Investor>? investors,
    double? stockPrice,
    String? facebook,
    String? linkToAnnouncement,
    String? cusip,
    String? tempLogo,
    DateTime? lastModified,
    double? marketCapStd,
  }) {
    return Fields(
      name: name ?? this.name,
      brands: brands ?? this.brands,
      action: action ?? this.action,
      logo: logo ?? this.logo,
      status: status ?? this.status,
      exception: exception ?? this.exception,
      country: country ?? this.country,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      sector: sector ?? this.sector,
      ticker: ticker ?? this.ticker,
      notes: notes ?? this.notes,
      marketCap: marketCap ?? this.marketCap,
      currency: currency ?? this.currency,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      investors: investors ?? this.investors,
      stockPrice: stockPrice ?? this.stockPrice,
      facebook: facebook ?? this.facebook,
      linkToAnnouncement: linkToAnnouncement ?? this.linkToAnnouncement,
      cusip: cusip ?? this.cusip,
      tempLogo: tempLogo ?? this.tempLogo,
      lastModified: lastModified ?? this.lastModified,
      marketCapStd: marketCapStd ?? this.marketCapStd,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Fields) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      name.hashCode ^
      brands.hashCode ^
      action.hashCode ^
      logo.hashCode ^
      status.hashCode ^
      exception.hashCode ^
      country.hashCode ^
      websiteUrl.hashCode ^
      instagram.hashCode ^
      twitter.hashCode ^
      sector.hashCode ^
      ticker.hashCode ^
      notes.hashCode ^
      marketCap.hashCode ^
      currency.hashCode ^
      industry.hashCode ^
      description.hashCode ^
      investors.hashCode ^
      stockPrice.hashCode ^
      facebook.hashCode ^
      linkToAnnouncement.hashCode ^
      cusip.hashCode ^
      tempLogo.hashCode ^
      lastModified.hashCode ^
      marketCapStd.hashCode;
}
