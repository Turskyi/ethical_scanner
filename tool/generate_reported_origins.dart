import 'dart:io';

/// Generates `lib/data/data_sources/local/reported_origins.g.dart` from the
/// evidence image files in `components/interface_adapters/assets/images/evidence/`.
///
/// Run with: `dart run tool/generate_reported_origins.dart`
void main() {
  generateReportedOriginsFile();
}

void generateReportedOriginsFile() {
  final Directory evidenceDir = Directory(
    'components/interface_adapters/assets/images/evidence',
  );

  if (!evidenceDir.existsSync()) {
    stderr.writeln('Directory not found: ${evidenceDir.path}');
    exit(1);
  } else {
    final List<FileSystemEntity> entities = evidenceDir.listSync();
    final Map<String, List<String>> photoMap = <String, List<String>>{};
    final Map<String, Set<String>> originSetMap = <String, Set<String>>{};

    final List<File> files =
        entities
            .whereType<File>()
            .where((File file) => !file.path.split('/').last.startsWith('.'))
            .toList()
          ..sort((File a, File b) => a.path.compareTo(b.path));

    for (final File file in files) {
      final String fileName = file.path.split('/').last;
      final int firstUnderscoreIndex = fileName.indexOf('_');
      if (firstUnderscoreIndex != -1) {
        final int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > firstUnderscoreIndex) {
          final String prefix = fileName.substring(0, firstUnderscoreIndex);
          final String rawCountry = fileName.substring(
            firstUnderscoreIndex + 1,
            lastDotIndex,
          );
          final String formattedCountry = formatCountryName(rawCountry);

          photoMap.putIfAbsent(prefix, () => <String>[]).add(fileName);
          originSetMap
              .putIfAbsent(prefix, () => <String>{})
              .add(formattedCountry);
        }
      }
    }

    final Map<String, String> originMap = <String, String>{};
    originSetMap.forEach((String prefix, Set<String> origins) {
      originMap[prefix] = origins.join(', ');
    });

    final String generatedContent = buildGeneratedContent(
      originMap: originMap,
      photoMap: photoMap,
    );

    final File outputFile = File(
      'lib/data/data_sources/local/reported_origins.g.dart',
    );
    outputFile.writeAsStringSync(generatedContent);
    stdout.writeln('Successfully generated ${outputFile.path}');
  }
}

String formatCountryName(String rawCountry) {
  final String lowercase = rawCountry.toLowerCase().trim();
  if (lowercase == 'england') {
    return 'United Kingdom (England)';
  } else {
    final String withSpaces = rawCountry.replaceAll('_', ' ');
    final List<String> words = withSpaces.split(' ');
    final List<String> capitalizedWords = <String>[];

    for (final String word in words) {
      if (word.isNotEmpty) {
        final String capitalized =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalized);
      }
    }

    return capitalizedWords.join(' ');
  }
}

String buildGeneratedContent({
  required Map<String, String> originMap,
  required Map<String, List<String>> photoMap,
}) {
  final StringBuffer buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln(
      '// Generated from files in components/interface_adapters/assets/images/evidence/',
    )
    ..writeln()
    ..writeln(
      '/// Map of GS1 prefix to evidence-based reported origin country name.',
    )
    ..writeln(
      'const Map<String, String> kReportedOriginMap = <String, String>{',
    );

  final List<String> originKeys = originMap.keys.toList()..sort();
  for (final String key in originKeys) {
    final String value = originMap[key]!;
    final String escapedValue = value.replaceAll("'", "\\'");
    buffer.writeln("  '$key': '$escapedValue',");
  }

  buffer
    ..writeln('};')
    ..writeln()
    ..writeln('/// Map of GS1 prefix to list of evidence photo file names.')
    ..writeln(
      'const Map<String, List<String>> kReportedOriginPhotoFileNamesMap =',
    )
    ..writeln('    <String, List<String>>{');

  final List<String> photoKeys = photoMap.keys.toList()..sort();
  for (final String key in photoKeys) {
    final List<String> filenames = photoMap[key]!;
    final String filenamesFormatted = filenames
        .map((String f) => "'$f'")
        .join(', ');
    buffer.writeln("  '$key': <String>[$filenamesFormatted],");
  }

  buffer.writeln('};');

  return buffer.toString();
}
