import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:interface_adapters/interface_adapters.dart';

/// The [HomeWidgetNavigationService] manages navigation when the user taps
/// the home screen widget on Android or iOS.
class HomeWidgetNavigationService {
  HomeWidgetNavigationService({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription<Uri?>? _widgetClickSubscription;

  static const String _expectedScheme = 'ethicalscanner';
  static const String _expectedHost = 'scan';

  /// Listens for widget tap events during warm start and processes initial
  /// launch URIs when starting cold.
  void initialize() {
    final bool isMobilePlatform =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    if (isMobilePlatform) {
      try {
        _widgetClickSubscription = HomeWidget.widgetClicked.listen((
          Uri? uri,
        ) {
          if (uri != null) {
            _handleWidgetUri(uri);
          }
        });
      } on MissingPluginException catch (e) {
        debugPrint('HomeWidget plugin not available: $e');
      } on PlatformException catch (e) {
        debugPrint('HomeWidget platform exception: $e');
      }

      try {
        HomeWidget.initiallyLaunchedFromHomeWidget().then((Uri? uri) {
          if (uri != null) {
            _handleWidgetUri(uri);
          }
        });
      } on MissingPluginException catch (e) {
        debugPrint('HomeWidget plugin not available: $e');
      } on PlatformException catch (e) {
        debugPrint('HomeWidget platform exception: $e');
      }
    }
  }

  void dispose() {
    _widgetClickSubscription?.cancel();
    _widgetClickSubscription = null;
  }

  void _handleWidgetUri(Uri uri) {
    final bool isScanUri =
        uri.scheme == _expectedScheme ||
        uri.host == _expectedHost ||
        uri.path == kScanPath ||
        uri.queryParameters.containsKey('homeWidget');

    if (isScanUri) {
      _navigateToScanScreen();
    }
  }

  void _navigateToScanScreen() {
    void performNavigation() {
      final NavigatorState? navigator = navigatorKey.currentState;
      if (navigator != null) {
        bool isScanOnTop = false;

        navigator.popUntil((Route<dynamic> route) {
          if (route.settings.name == kScanPath) {
            isScanOnTop = true;
          }
          return true;
        });

        if (!isScanOnTop) {
          navigator.pushNamed(kScanPath);
        }
      }
    }

    if (navigatorKey.currentState != null) {
      performNavigation();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        performNavigation();
      });
    }
  }
}
