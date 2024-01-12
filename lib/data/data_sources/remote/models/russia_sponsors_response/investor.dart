import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'investor.g.dart';

@JsonSerializable()
class Investor {
  const Investor({
    this.symbol,
    this.id,
    this.adjHolding,
    this.adjMv,
    this.entityProperName,
    this.reportDate,
    this.filingDate,
    this.reportedHolding,
    this.date,
    this.updated,
  });

  factory Investor.fromJson(Map<String, dynamic> json) {
    return _$InvestorFromJson(json);
  }

  final String? symbol;
  final String? id;
  final double? adjHolding;
  final int? adjMv;
  final String? entityProperName;
  final int? reportDate;
  final String? filingDate;
  final int? reportedHolding;
  final int? date;
  final int? updated;

  @override
  String toString() {
    return 'Investor(symbol: $symbol, id: $id, adjHolding: $adjHolding, '
        'adjMv: $adjMv, entityProperName: $entityProperName, '
        'reportDate: $reportDate, filingDate: $filingDate, '
        'reportedHolding: $reportedHolding, date: $date, updated: $updated)';
  }

  Map<String, dynamic> toJson() => _$InvestorToJson(this);

  Investor copyWith({
    String? symbol,
    String? id,
    double? adjHolding,
    int? adjMv,
    String? entityProperName,
    int? reportDate,
    String? filingDate,
    int? reportedHolding,
    int? date,
    int? updated,
  }) {
    return Investor(
      symbol: symbol ?? this.symbol,
      id: id ?? this.id,
      adjHolding: adjHolding ?? this.adjHolding,
      adjMv: adjMv ?? this.adjMv,
      entityProperName: entityProperName ?? this.entityProperName,
      reportDate: reportDate ?? this.reportDate,
      filingDate: filingDate ?? this.filingDate,
      reportedHolding: reportedHolding ?? this.reportedHolding,
      date: date ?? this.date,
      updated: updated ?? this.updated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Investor) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      symbol.hashCode ^
      id.hashCode ^
      adjHolding.hashCode ^
      adjMv.hashCode ^
      entityProperName.hashCode ^
      reportDate.hashCode ^
      filingDate.hashCode ^
      reportedHolding.hashCode ^
      date.hashCode ^
      updated.hashCode;
}
