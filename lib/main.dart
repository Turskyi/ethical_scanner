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
/// It is in this [main] component that [Dependencies] should be injected.
/// The [main] is a dirty low-level module in the outermost circle of the clean
/// architecture.
/// Think of [main] as a plugin to the [App] — a plugin that sets up the
/// initial conditions and configurations, gathers all the outside resources,
/// and then hands control over to the high-level policy of the [App].
/// When [main] is released, it has utterly no effect on any of the other
/// components in the system. They don’t know about [main], and they don’t care
/// when it changes.
void main() async {
  LocalizationDelegate localizationDelegate = await getLocalizationDelegate();

  // Filter the `OpenFoodFactsLanguage` values based on the `Language` enum.
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
