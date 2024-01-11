import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'full.dart';
import 'large.dart';
import 'small.dart';

part 'thumbnails.g.dart';

@JsonSerializable()
class Thumbnails {
  const Thumbnails({this.small, this.large, this.full});

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return _$ThumbnailsFromJson(json);
  }

  final Small? small;
  final Large? large;
  final Full? full;

  @override
  String toString() {
    return 'Thumbnails(small: $small, large: $large, full: $full)';
  }

  Map<String, dynamic> toJson() => _$ThumbnailsToJson(this);

  Thumbnails copyWith({
    Small? small,
    Large? large,
    Full? full,
  }) {
    return Thumbnails(
      small: small ?? this.small,
      large: large ?? this.large,
      full: full ?? this.full,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Thumbnails) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => small.hashCode ^ large.hashCode ^ full.hashCode;
}
