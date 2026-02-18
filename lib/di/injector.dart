import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/localization_delelegate_getter.dart';
import 'package:ethical_scanner/res/values/constants.dart' as constants;
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart' as cameras;
import 'package:interface_adapters/interface_adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<Dependencies> injectAndGetDependencies() async {
  OpenAI.apiKey = Env.openAiApiKey;

  OpenFoodAPIConfiguration.globalUser = const User(
    userId: Env.openFoodUserId,
    password: Env.openFoodPassword,
    comment: constants.openFoodUserComment,
  );

  // Filter the `OpenFoodFactsLanguage` values based on the `Language` enum.
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

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: packageInfo.appName,
    version: packageInfo.version,
    system: kIsWeb ? 'Web' : Platform.operatingSystem,
    url: constants.webPage,
    comment: constants.userAgentComment,
  );

  try {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      // Fetch the available cameras before initializing the app.
      cameras.cameraDescriptions = await availableCameras();
    }
  } on CameraException catch (exception, stacktrace) {
    debugPrint('Error: $exception\nStacktrace: $stacktrace');
  }

  final LocalizationDelegate localizationDelegate =
      await getLocalizationDelegate();

  final Dependencies dependencies = await Dependencies.create(
    localizationDelegate: localizationDelegate,
  );
  return dependencies;
}
