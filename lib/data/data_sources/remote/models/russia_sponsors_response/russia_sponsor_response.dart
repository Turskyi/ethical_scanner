import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fields.dart';

part 'russia_sponsors_response.g.dart';

@JsonSerializable()
class RussiaSponsorsResponse {

  const RussiaSponsorsResponse({this.id, this.createdTime, this.fields});

  factory RussiaSponsorsResponse.fromJson(Map<String, dynamic> json) {
    return _$RussiaSponsorsResponseFromJson(json);
  }
  final String? id;
  final DateTime? createdTime;
  final Fields? fields;

  @override
  String toString() {
    return 'RussiaSponsorsResponse(id: $id, createdTime: $createdTime, fields: $fields)';
  }

  Map<String, dynamic> toJson() => _$RussiaSponsorsResponseToJson(this);

  RussiaSponsorsResponse copyWith({
    String? id,
    DateTime? createdTime,
    Fields? fields,
  }) {
    return RussiaSponsorsResponse(
      id: id ?? this.id,
      createdTime: createdTime ?? this.createdTime,
      fields: fields ?? this.fields,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RussiaSponsorsResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ createdTime.hashCode ^ fields.hashCode;
}
