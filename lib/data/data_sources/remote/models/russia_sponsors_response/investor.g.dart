// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Investor _$InvestorFromJson(Map<String, dynamic> json) => Investor(
      symbol: json['symbol'] as String?,
      id: json['id'] as String?,
      adjHolding: (json['adjHolding'] as num?)?.toDouble(),
      adjMv: (json['adjMv'] as num?)?.toInt(),
      entityProperName: json['entityProperName'] as String?,
      reportDate: (json['reportDate'] as num?)?.toInt(),
      filingDate: json['filingDate'] as String?,
      reportedHolding: (json['reportedHolding'] as num?)?.toInt(),
      date: (json['date'] as num?)?.toInt(),
      updated: (json['updated'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InvestorToJson(Investor instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'id': instance.id,
      'adjHolding': instance.adjHolding,
      'adjMv': instance.adjMv,
      'entityProperName': instance.entityProperName,
      'reportDate': instance.reportDate,
      'filingDate': instance.filingDate,
      'reportedHolding': instance.reportedHolding,
      'date': instance.date,
      'updated': instance.updated,
    };
