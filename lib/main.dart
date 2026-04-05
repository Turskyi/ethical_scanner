import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart' as route;
import 'package:interface_adapters/interface_adapters.dart';
import 'package:intl/intl.dart';
import 'package:use_cases/use_cases.dart';

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
  // Ensures that Flutter's internal bindings are initialized before executing
  // any asynchronous platform-specific logic. This is required for services
  // like PackageInfo and camera access to function correctly during startup
  // and avoids potential UI freezes or blank screens.
  WidgetsFlutterBinding.ensureInitialized();

  final Dependencies dependencies = await injectAndGetDependencies();

  Language initialLanguage = dependencies.getLanguageUseCase();

  if (kIsWeb) {
    // Retrieves the host name (e.g., "localhost" or "uk.ethical-scanner.com").
    initialLanguage = await _resolveInitialLanguageFromUrl(
      initialLanguage: initialLanguage,
      saveLanguageUseCase: dependencies.saveLanguageUseCase,
    );
  }

  final LocalizationDelegate localizationDelegate =
      dependencies.localizationDelegate;

  final Language currentLanguage = Language.fromIsoLanguageCode(
    localizationDelegate.currentLocale.languageCode,
  );

  if (initialLanguage != currentLanguage) {
    _applyInitialLocale(
      initialLanguage: initialLanguage,
      localizationDelegate: localizationDelegate,
    );
  }

  // Create an instance of the router.
  final AppRouter appRouter = AppRouter(savedLanguage: initialLanguage);

  runApp(
    App.factory(
      dependencies: dependencies,
      localizationDelegate: localizationDelegate,
      onGenerateRoute: appRouter.generateRoute,
    ),
  );
}

Future<Language> _resolveInitialLanguageFromUrl({
  required Language initialLanguage,
  required UseCase<Future<bool>, String> saveLanguageUseCase,
}) async {
  // Retrieves the host name (e.g., "localhost" or "uk.ethical-scanner.com").
  final String host = Uri.base.host;

  // Retrieves the fragment (e.g., "/en" or "/uk").
  final String fragment = Uri.base.fragment;

  for (final Language language in Language.values) {
    final String currentLanguageCode = language.isoLanguageCode;
    if (host.startsWith('$currentLanguageCode.') ||
        fragment.contains('${route.kHomePath}$currentLanguageCode')) {
      try {
        Intl.defaultLocale = currentLanguageCode;
      } catch (e, stackTrace) {
        debugPrint(
          'Failed to set Intl.defaultLocale to "$currentLanguageCode".\n'
          'Error: $e\n'
          'StackTrace: $stackTrace\n'
          'Proceeding with previously set default locale or system default.',
        );
      }
      initialLanguage = language;
      // We save it so the rest of the app (like recommendations) uses this
      // language.
      await saveLanguageUseCase.call(currentLanguageCode);
      break;
    }
  }
  return initialLanguage;
}

void _applyInitialLocale({
  required Language initialLanguage,
  required LocalizationDelegate localizationDelegate,
}) {
  final Locale locale = localeFromString(initialLanguage.isoLanguageCode);

  localizationDelegate.changeLocale(locale);

  // Notify listeners that the locale has changed so they can update.
  localizationDelegate.onLocaleChanged?.call(locale);
}
