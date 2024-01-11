// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'russia_sponsors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RussiaSponsorsResponse _$RussiaSponsorsResponseFromJson(
        Map<String, dynamic> json) =>
    RussiaSponsorsResponse(
      id: json['id'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      fields: json['fields'] == null
          ? null
          : Fields.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RussiaSponsorsResponseToJson(
        RussiaSponsorsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdTime': instance.createdTime?.toIso8601String(),
      'fields': instance.fields,
    };
