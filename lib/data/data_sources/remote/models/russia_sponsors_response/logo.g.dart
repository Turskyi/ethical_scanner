// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Logo _$LogoFromJson(Map<String, dynamic> json) => Logo(
      id: json['id'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      url: json['url'] as String?,
      filename: json['filename'] as String?,
      size: (json['size'] as num?)?.toInt(),
      type: json['type'] as String?,
      thumbnails: json['thumbnails'] == null
          ? null
          : Thumbnails.fromJson(json['thumbnails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LogoToJson(Logo instance) => <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'filename': instance.filename,
      'size': instance.size,
      'type': instance.type,
      'thumbnails': instance.thumbnails,
    };
