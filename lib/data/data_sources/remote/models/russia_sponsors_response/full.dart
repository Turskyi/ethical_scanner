import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'full.g.dart';

@JsonSerializable()
class Full {
  final String? url;
  final int? width;
  final int? height;

  const Full({this.url, this.width, this.height});

  @override
  String toString() => 'Full(url: $url, width: $width, height: $height)';

  factory Full.fromJson(Map<String, dynamic> json) => _$FullFromJson(json);

  Map<String, dynamic> toJson() => _$FullToJson(this);

  Full copyWith({
    String? url,
    int? width,
    int? height,
  }) {
    return Full(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Full) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => url.hashCode ^ width.hashCode ^ height.hashCode;
}
