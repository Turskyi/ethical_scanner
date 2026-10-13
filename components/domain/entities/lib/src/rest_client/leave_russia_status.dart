class LeaveRussiaStatus {
  const LeaveRussiaStatus({this.key = '', this.en = '', this.uk = ''});

  factory LeaveRussiaStatus.fromJson(Object? json) {
    final Map<String, Object?> map = json is Map<String, Object?>
        ? json
        : const <String, Object?>{};
    return LeaveRussiaStatus(
      key: map[_keyJsonKey] as String? ?? '',
      en: map[_enJsonKey] as String? ?? '',
      uk: map[_ukJsonKey] as String? ?? '',
    );
  }

  final String key;
  final String en;
  final String uk;

  static const String stayKey = 'stay';
  static const String leaveKey = 'leave';
  static const String exitedKey = 'exited';

  static const String _keyJsonKey = 'key';
  static const String _enJsonKey = 'en';
  static const String _ukJsonKey = 'uk';

  bool get isStay => key.toLowerCase().trim() == stayKey;
  bool get isLeave => key.toLowerCase().trim() == leaveKey;
  bool get isExited => key.toLowerCase().trim() == exitedKey;
  bool get isLeavingOrExited => isLeave || isExited;

  Map<String, Object?> toJson() => <String, Object?>{
    _keyJsonKey: key,
    _enJsonKey: en,
    _ukJsonKey: uk,
  };
}
