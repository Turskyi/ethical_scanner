// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Investor _$InvestorFromJson(Map<String, dynamic> json) => Investor(
      symbol: json['symbol'] as String?,
      id: json['id'] as String?,
      adjHolding: json['adjHolding'] as int?,
      adjMv: json['adjMv'] as int?,
      entityProperName: json['entityProperName'] as String?,
      reportDate: json['reportDate'] as int?,
      filingDate: json['filingDate'] as String?,
      reportedHolding: json['reportedHolding'] as int?,
      date: json['date'] as int?,
      updated: json['updated'] as int?,
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
