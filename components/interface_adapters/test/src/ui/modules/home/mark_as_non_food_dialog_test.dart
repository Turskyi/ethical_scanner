import 'package:entities/entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/mark_as_non_food_dialog.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../ingredients_editor/fake_localization_delegate.dart';
import 'mark_as_non_food_dialog_test.mocks.dart';

@GenerateMocks(<Type>[HomePresenter])
void main() {
  late MockHomePresenter mockHomePresenter;
  late FakeLocalizationDelegate localizationDelegate;

  setUp(() {
    mockHomePresenter = MockHomePresenter();
    when(
      mockHomePresenter.stream,
    ).thenAnswer((_) => const Stream<HomeViewModel>.empty());
    when(
      mockHomePresenter.state,
    ).thenReturn(const ReadyToScanState(language: Language.en));
    localizationDelegate = FakeLocalizationDelegate();
    Localization.load(<String, Object?>{
      'product_info': <String, Object?>{
        'mark_as_non_food_dialog_title': 'Mark as non-food product?',
        'mark_as_non_food_dialog_content':
            'Are you sure you want to mark this item as a non-food product or '
            'device?',
        'mark_as_non_food_confirm': 'Mark as non-food',
      },
      'close': 'Close',
    });
  });

  Widget buildTestWidget() {
    return LocalizedApp(
      localizationDelegate,
      Resources(
        colors: MaterialColors(),
        gradients: Gradients(),
        child: MaterialApp(
          home: Scaffold(
            body: BlocProvider<HomePresenter>.value(
              value: mockHomePresenter,
              child: const MarkAsNonFoodDialog(barcode: '123456789'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders title, content, close, and confirm buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Mark as non-food product?'), findsOneWidget);
    expect(
      find.text(
        'Are you sure you want to mark this item as a non-food product or '
        'device?',
      ),
      findsOneWidget,
    );
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Mark as non-food'), findsOneWidget);
  });

  testWidgets('dispatches MarkAsNonFoodProductEvent when confirm is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    await tester.tap(find.text('Mark as non-food'));
    await tester.pumpAndSettle();

    verify(
      mockHomePresenter.add(
        argThat(
          isA<MarkAsNonFoodProductEvent>().having(
            (MarkAsNonFoodProductEvent e) => e.barcode,
            'barcode',
            '123456789',
          ),
        ),
      ),
    ).called(1);
  });
}
