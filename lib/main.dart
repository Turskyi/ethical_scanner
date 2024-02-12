import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/di/injector.dart';
import 'package:ethical_scanner/localization_delelegate_getter.dart';
import 'package:ethical_scanner/routes/router.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
/// It is the initial entry point of the system.
/// Nothing, other than the operating system, depends on it.
/// Think of [main] as a plugin to the [App]. Its job is to create all the
/// factories, strategies, and other global facilities, and then hand control
/// over to the high-level policy of the [App].
void main() async {
  /// Get the singleton instance of the `PlatformDispatcher`.
  LocalizationDelegate localizationDelegate = await getLocalizationDelegate();

  /// Filter the `OpenFoodFactsLanguage` values based on the `Language` enum.
  Dependencies dependencies = await injectAndGetDependencies();

  runApp(
    BetterFeedback(
      child: LocalizedApp(
        localizationDelegate,
        DependenciesScope(
          dependencies: dependencies,
          child: App.factory(generateRoute),
        ),
      ),
    ),
  );
}
