enum Settings { precipitationFalling }

extension SettingsExtension on Settings {
  String get key {
    switch (this) {
      case Settings.precipitationFalling:
        return 'precipitationFalling';
    }
  }
}
