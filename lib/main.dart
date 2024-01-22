import 'package:dart_openai/dart_openai.dart';
import 'package:ethical_scanner/constants.dart' as constants;
import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/res/enums/language.dart';
import 'package:ethical_scanner/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'env/env.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
/// It is the initial entry point of the system.
/// Nothing, other than the operating system, depends on it.
/// Think of [main] as a plugin to the [App]. Its job is to create all the
/// factories, strategies, and other global facilities, and then hand control
/// over to the high-level policy of the [App].
void main() async {
  LocalizationDelegate localizationDelegate = await LocalizationDelegate.create(
    fallbackLocale: Language.en.name,
    supportedLocales: <String>[Language.en.name],
    basePath: constants.localePath,
  );

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: constants.useAgentAppName,
  );

  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH,
  ];

  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;

  OpenAI.apiKey = Env.apiKey;

  WidgetsFlutterBinding.ensureInitialized();
  await LocalDataSourceImpl().init();

  runApp(
    LocalizedApp(
      localizationDelegate,
      DependenciesScope(
        dependencies: const Dependencies(),
        child: App.factory(generateRoute),
      ),
    ),
  );
}
