import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'thumbnails.dart';

part 'logo.g.dart';

@JsonSerializable()
class Logo {
  const Logo({
    this.id,
    this.width,
    this.height,
    this.url,
    this.filename,
    this.size,
    this.type,
    this.thumbnails,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => _$LogoFromJson(json);
  final String? id;
  final int? width;
  final int? height;
  final String? url;
  final String? filename;
  final int? size;
  final String? type;
  final Thumbnails? thumbnails;

  @override
  String toString() {
    return 'Logo(id: $id, width: $width, height: $height, url: $url, '
        'filename: $filename, size: $size, type: $type, '
        'thumbnails: $thumbnails)';
  }

  Map<String, dynamic> toJson() => _$LogoToJson(this);

  Logo copyWith({
    String? id,
    int? width,
    int? height,
    String? url,
    String? filename,
    int? size,
    String? type,
    Thumbnails? thumbnails,
  }) {
    return Logo(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
      filename: filename ?? this.filename,
      size: size ?? this.size,
      type: type ?? this.type,
      thumbnails: thumbnails ?? this.thumbnails,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Logo) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      width.hashCode ^
      height.hashCode ^
      url.hashCode ^
      filename.hashCode ^
      size.hashCode ^
      type.hashCode ^
      thumbnails.hashCode;
}
