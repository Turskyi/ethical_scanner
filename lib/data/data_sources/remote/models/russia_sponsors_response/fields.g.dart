// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fields _$FieldsFromJson(Map<String, dynamic> json) => Fields(
      name: json['Name'] as String?,
      action: json['Action'] as String?,
      logo: (json['Logo'] as List<dynamic>?)
          ?.map((e) => Logo.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['Status'] as String?,
      exception: json['Exception'] as String?,
      country: json['Country'] as String?,
      websiteUrl: json['Website URL'] as String?,
      instagram: json['Instagram'] as String?,
      twitter: json['Twitter'] as String?,
      sector: json['Sector'] as String?,
      ticker: json['Ticker'] as String?,
      notes: json['Notes'] as String?,
      marketCap: json['Market Cap'] as int?,
      currency: json['Currency'] as String?,
      industry: json['Industry'] as String?,
      description: json['Description'] as String?,
      investors: (json['Investors'] as List<dynamic>?)
          ?.map((e) => Investor.fromJson(e as Map<String, dynamic>))
          .toList(),
      stockPrice: (json['Stock Price'] as num?)?.toDouble(),
      facebook: json['Facebook'] as String?,
      linkToAnnouncement: json['Link to Announcement'] as String?,
      cusip: json['CUSIP'] as String?,
      tempLogo: json['Temp Logo'] as String?,
      lastModified: json['Last Modified'] == null
          ? null
          : DateTime.parse(json['Last Modified'] as String),
      marketCapStd: (json['Market Cap (Std)'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FieldsToJson(Fields instance) => <String, dynamic>{
      'Name': instance.name,
      'Action': instance.action,
      'Logo': instance.logo,
      'Status': instance.status,
      'Exception': instance.exception,
      'Country': instance.country,
      'Website URL': instance.websiteUrl,
      'Instagram': instance.instagram,
      'Twitter': instance.twitter,
      'Sector': instance.sector,
      'Ticker': instance.ticker,
      'Notes': instance.notes,
      'Market Cap': instance.marketCap,
      'Currency': instance.currency,
      'Industry': instance.industry,
      'Description': instance.description,
      'Investors': instance.investors,
      'Stock Price': instance.stockPrice,
      'Facebook': instance.facebook,
      'Link to Announcement': instance.linkToAnnouncement,
      'CUSIP': instance.cusip,
      'Temp Logo': instance.tempLogo,
      'Last Modified': instance.lastModified?.toIso8601String(),
      'Market Cap (Std)': instance.marketCapStd,
    };
