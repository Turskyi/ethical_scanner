/// A bundled document (PDF asset) that serves as official evidence
/// recognizing a country as a sponsor of terrorism.
///
/// [titleKey] and [descriptionKey] are i18n translation keys.
/// [assetPath] is the Flutter asset path registered in pubspec.yaml.
/// [fileName] is the suggested file name when saving to the device.
class SponsorDocument {
  const SponsorDocument({
    required this.titleKey,
    required this.descriptionKey,
    required this.assetPath,
    required this.fileName,
  });

  final String titleKey;
  final String descriptionKey;
  final String assetPath;
  final String fileName;
}
