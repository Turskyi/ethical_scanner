import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/generate_reported_origins.dart';

void main() {
  test(
    'automatically generates reported_origins.g.dart from evidence files',
    () {
      generateReportedOriginsFile();

      final Directory evidenceDir = Directory(
        'components/interface_adapters/assets/images/evidence',
      );
      expect(evidenceDir.existsSync(), isTrue);

      final File generatedFile = File(
        'lib/data/data_sources/local/reported_origins.g.dart',
      );
      expect(generatedFile.existsSync(), isTrue);
    },
  );
}
