import 'package:dart_openai/dart_openai.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/res/enums/language.dart';
import 'package:ethical_scanner/res/strings.dart';
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
    basePath: Strings.localePath,
  );

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'ethical_scanner',
  );

  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH,
  ];

  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;

  OpenAI.apiKey = Env.apiKey;

  runApp(
    LocalizedApp(
      localizationDelegate,
      DependenciesScope(
        dependencies: const Dependencies(),
        child: App(generateRoute),
      ),
    ),
  );
}
