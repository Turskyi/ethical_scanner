import 'leave_russia_item.dart';

class LeaveRussiaResponse {
  const LeaveRussiaResponse({this.data = const <LeaveRussiaItem>[]});

  factory LeaveRussiaResponse.fromJson(Object? json) {
    if (json is Map<String, Object?>) {
      final Object? dataList = json[_dataJsonKey];
      if (dataList is List) {
        final List<LeaveRussiaItem> items = dataList
            .whereType<Map<String, Object?>>()
            .map((Map<String, Object?> e) => LeaveRussiaItem.fromJson(e))
            .toList();
        return LeaveRussiaResponse(data: items);
      }
    }
    return const LeaveRussiaResponse();
  }

  final List<LeaveRussiaItem> data;

  /// Sentinel string cached in local storage to record a confirmed cache miss.
  static const String cacheMissSentinel = 'NOT_FOUND';
  static const String _dataJsonKey = 'data';

  LeaveRussiaItem? get firstItem => data.firstOrNull;

  Map<String, Object?> toJson() => <String, Object?>{
    _dataJsonKey: data.map((LeaveRussiaItem item) => item.toJson()).toList(),
  };
}
