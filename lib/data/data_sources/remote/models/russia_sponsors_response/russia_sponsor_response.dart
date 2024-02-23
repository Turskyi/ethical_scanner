import 'package:collection/collection.dart';
import 'package:entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fields.dart';

part 'russia_sponsor_response.g.dart';

@JsonSerializable()
class RussiaSponsorResponse implements TerrorismSponsor {
  const RussiaSponsorResponse({
    required this.id,
    required this.fields,
    this.createdTime,
  });

  factory RussiaSponsorResponse.fromJson(Map<String, dynamic> json) {
    return _$RussiaSponsorResponseFromJson(json);
  }

  @override
  final String id;
  final DateTime? createdTime;
  final Fields fields;

  @override
  String toString() {
    return 'RussiaSponsorsResponse(id: $id, createdTime: $createdTime, '
        'fields: $fields)';
  }

  Map<String, dynamic> toJson() => _$RussiaSponsorResponseToJson(this);

  RussiaSponsorResponse copyWith({
    String? id,
    DateTime? createdTime,
    Fields? fields,
  }) =>
      RussiaSponsorResponse(
        id: id ?? this.id,
        createdTime: createdTime ?? this.createdTime,
        fields: fields ?? this.fields,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RussiaSponsorResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ createdTime.hashCode ^ fields.hashCode;

  @override
  String get status => fields.status ?? '';

  @override
  String get name => fields.name;

  @override
  String get brands => fields.brands;
}
