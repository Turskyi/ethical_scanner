import 'leave_russia_company_page.dart';
import 'leave_russia_status.dart';

class LeaveRussiaItem {
  const LeaveRussiaItem({
    this.name = '',
    this.companyName = '',
    this.status,
    this.companyPage,
  });

  factory LeaveRussiaItem.fromJson(Object? json) {
    final Map<String, Object?> map = json is Map<String, Object?>
        ? json
        : const <String, Object?>{};
    return LeaveRussiaItem(
      name: map[_nameJsonKey] as String? ?? '',
      companyName: map[_companyNameJsonKey] as String? ?? '',
      status: map[_statusJsonKey] is Map<String, Object?>
          ? LeaveRussiaStatus.fromJson(map[_statusJsonKey])
          : null,
      companyPage: map[_companyPageJsonKey] is Map<String, Object?>
          ? LeaveRussiaCompanyPage.fromJson(map[_companyPageJsonKey])
          : null,
    );
  }

  final String name;
  final String companyName;
  final LeaveRussiaStatus? status;
  final LeaveRussiaCompanyPage? companyPage;

  static const String _nameJsonKey = 'name';
  static const String _companyNameJsonKey = 'company_name';
  static const String _statusJsonKey = 'status';
  static const String _companyPageJsonKey = 'companypage';

  String get displayName => companyName.isNotEmpty ? companyName : name;

  Map<String, Object?> toJson() {
    final LeaveRussiaStatus? currentStatus = status;
    final LeaveRussiaCompanyPage? currentPage = companyPage;

    return <String, Object?>{
      _nameJsonKey: name,
      _companyNameJsonKey: companyName,
      if (currentStatus != null) _statusJsonKey: currentStatus.toJson(),
      if (currentPage != null) _companyPageJsonKey: currentPage.toJson(),
    };
  }
}
