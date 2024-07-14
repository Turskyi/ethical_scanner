// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'small.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Small _$SmallFromJson(Map<String, dynamic> json) => Small(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SmallToJson(Small instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
