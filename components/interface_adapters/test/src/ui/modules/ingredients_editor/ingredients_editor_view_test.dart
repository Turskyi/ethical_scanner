import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_presenter.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/view/ingredients_editor_view.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:mockito/mockito.dart';

import 'fake_localization_delegate.dart';
import 'ingredients_editor_presenter_test.mocks.dart';

void main() {
  testWidgets('applies the saved Ukrainian locale when the editor opens', (
    WidgetTester tester,
  ) async {
    final MockExtractIngredientsUseCase mockExtractIngredientsUseCase =
        MockExtractIngredientsUseCase();
    final MockSaveIngredientsUseCase mockSaveIngredientsUseCase =
        MockSaveIngredientsUseCase();
    final MockSaveLanguageUseCase mockSaveLanguageUseCase =
        MockSaveLanguageUseCase();
    final MockGetLanguageUseCase mockGetLanguageUseCase =
        MockGetLanguageUseCase();

    when(mockGetLanguageUseCase.call()).thenReturn(Language.uk);
    when(mockExtractIngredientsUseCase.call(any)).thenAnswer((_) async => '');

    final IngredientsEditorPresenter presenter = IngredientsEditorPresenter(
      mockSaveLanguageUseCase,
      mockExtractIngredientsUseCase,
      mockSaveIngredientsUseCase,
      mockGetLanguageUseCase,
    );

    final FakeLocalizationDelegate localizationDelegate =
        FakeLocalizationDelegate();
    Localization.load(<String, Object?>{
      'photo': <String, Object?>{
        'extract_ingredients': 'Вилучити текст інгредієнтів',
      },
      'product_info': <String, Object?>{'ingredients': 'Інгредієнти'},
      'save': 'Зберегти',
    });

    await tester.pumpWidget(
      LocalizedApp(
        localizationDelegate,
        Resources(
          colors: MaterialColors(),
          gradients: Gradients(),
          child: MaterialApp(
            home: BlocProvider<IngredientsEditorPresenter>(
              create: (BuildContext _) => presenter,
              child: const IngredientsEditorView(productInfo: ProductInfo()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(
      localizationDelegate.currentLocale.languageCode,
      Language.uk.isoLanguageCode,
    );
    expect(find.text('Вилучити текст інгредієнтів'), findsOneWidget);
    expect(find.text('Інгредієнти'), findsOneWidget);
    expect(find.text('Зберегти'), findsOneWidget);
  });
}
