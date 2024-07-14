// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Full _$FullFromJson(Map<String, dynamic> json) => Full(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FullToJson(Full instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
