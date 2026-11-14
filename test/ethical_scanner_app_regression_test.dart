import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:material_ui/material_ui.dart';

import '../components/interface_adapters/test/src/ui/modules/ingredients_editor/fake_localization_delegate.dart';
import 'mock_dependencies.dart';

void main() {
  testWidgets('EthicalScannerApp provides MaterialLocalizations '
      'for AdaptiveTextSelectionToolbar in BetterFeedback overlay', (
    WidgetTester tester,
  ) async {
    // Arrange
    WidgetsFlutterBinding.ensureInitialized();
    final FakeLocalizationDelegate localizationDelegate =
        FakeLocalizationDelegate();

    Localization.load(<String, Object?>{'title': 'Ethical Scanner'});

    final MockDependencies dependencies = await MockDependencies.create();

    final AppRouter appRouter = AppRouter(savedLanguage: Language.en);
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    final Widget app = App.factory(
      dependencies: dependencies,
      localizationDelegate: localizationDelegate,
      onGenerateRoute: appRouter.generateRoute,
      navigatorKey: navigatorKey,
    );

    // Act
    await tester.pumpWidget(app);
    await tester.pump();

    // Find the root Overlay (which belongs to BetterFeedback)
    final Element overlayElement = tester.element(find.byType(Overlay).first);

    // Verify that package:material_ui's MaterialLocalizations is found
    // in BetterFeedback's Overlay context
    expect(MaterialLocalizations.of(overlayElement), isNotNull);
  });
}
