import 'package:ethical_scanner/services/home_widget_navigation_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeWidgetNavigationService', () {
    test('can be instantiated, initialized and disposed cleanly', () {
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      final HomeWidgetNavigationService service = HomeWidgetNavigationService(
        navigatorKey: navigatorKey,
      );

      expect(service, isNotNull);
      expect(service.navigatorKey, equals(navigatorKey));

      service.initialize();
      service.dispose();
    });
  });
}
