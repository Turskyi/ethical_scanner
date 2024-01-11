import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'small.g.dart';

@JsonSerializable()
class Small {
  final String? url;
  final int? width;
  final int? height;

  const Small({this.url, this.width, this.height});

  @override
  String toString() => 'Small(url: $url, width: $width, height: $height)';

  factory Small.fromJson(Map<String, dynamic> json) => _$SmallFromJson(json);

  Map<String, dynamic> toJson() => _$SmallToJson(this);

  Small copyWith({
    String? url,
    int? width,
    int? height,
  }) {
    return Small(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Small) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => url.hashCode ^ width.hashCode ^ height.hashCode;
}
