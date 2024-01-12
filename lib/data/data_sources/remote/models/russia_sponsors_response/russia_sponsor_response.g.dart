// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'russia_sponsor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RussiaSponsorResponse _$RussiaSponsorResponseFromJson(
        Map<String, dynamic> json) =>
    RussiaSponsorResponse(
      id: json['id'] as String,
      fields: Fields.fromJson(json['fields'] as Map<String, dynamic>),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$RussiaSponsorResponseToJson(
        RussiaSponsorResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdTime': instance.createdTime?.toIso8601String(),
      'fields': instance.fields,
    };
