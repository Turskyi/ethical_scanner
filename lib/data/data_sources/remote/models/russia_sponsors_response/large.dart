import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'large.g.dart';

@JsonSerializable()
class Large {
  final String? url;
  final int? width;
  final int? height;

  const Large({this.url, this.width, this.height});

  @override
  String toString() => 'Large(url: $url, width: $width, height: $height)';

  factory Large.fromJson(Map<String, dynamic> json) => _$LargeFromJson(json);

  Map<String, dynamic> toJson() => _$LargeToJson(this);

  Large copyWith({
    String? url,
    int? width,
    int? height,
  }) {
    return Large(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Large) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => url.hashCode ^ width.hashCode ^ height.hashCode;
}
