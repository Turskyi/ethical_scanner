import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/camera_descriptions.dart' as cameras;
import 'package:ethical_scanner/constants.dart' as constants;
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/routes/router.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
/// It is the initial entry point of the system.
/// Nothing, other than the operating system, depends on it.
/// Think of [main] as a plugin to the [App]. Its job is to create all the
/// factories, strategies, and other global facilities, and then hand control
/// over to the high-level policy of the [App].
void main() async {
  /// Get the singleton instance of the `PlatformDispatcher`.
  PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;

  /// Get the current locale from the `PlatformDispatcher`.
  Locale deviceLocale = platformDispatcher.locale;

  /// Get the language code from the `Locale`.
  String deviceIsoLanguageCode = deviceLocale.languageCode;

  LocalizationDelegate localizationDelegate = await LocalizationDelegate.create(
    fallbackLocale: Language.fromIsoLanguageCode(
      deviceIsoLanguageCode,
    ).isoLanguageCode,
    supportedLocales: Language.values
        .map((Language language) => language.isoLanguageCode)
        .toList(),
    basePath: constants.localePath,
  );

  /// Filter the `OpenFoodFactsLanguage` values based on the `Language` enum.
  OpenFoodAPIConfiguration.globalLanguages = OpenFoodFactsLanguage.values
      .where(
        // Compare the code of the OpenFoodFactsLanguage value with the
        // `isoLanguageCode` of each Language enum value.
        (OpenFoodFactsLanguage openFoodFactsLanguage) => Language.values.any(
          (Language language) =>
              language.isoLanguageCode == openFoodFactsLanguage.code,
        ),
      )
      .toList();

  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;

  OpenAI.apiKey = Env.apiKey;

  OpenFoodAPIConfiguration.globalUser = const User(
    userId: Env.openFoodUserId,
    password: Env.openFoodPassword,
    comment: constants.openFoodUserComment,
  );

  /// Needed for `Dependencies`, `PackageInfo.fromPlatform()` and
  /// `availableCameras`.
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: packageInfo.appName,
    version: packageInfo.version,
    system: Platform.operatingSystem,
    url: constants.webPage,
    comment: constants.userAgentComment,
  );

  // Fetch the available cameras before initializing the app.
  try {
    cameras.cameraDescriptions = await availableCameras();
  } on CameraException catch (exception, stacktrace) {
    debugPrint('Error: $exception\nStacktrace: $stacktrace');
  }

  runApp(
    BetterFeedback(
      child: LocalizedApp(
        localizationDelegate,
        DependenciesScope(
          dependencies: Dependencies(),
          child: App.factory(generateRoute),
        ),
      ),
    ),
  );
}
