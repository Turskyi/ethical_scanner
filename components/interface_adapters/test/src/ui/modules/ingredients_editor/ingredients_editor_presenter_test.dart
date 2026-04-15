import 'package:bloc_test/bloc_test.dart';
import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_event.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_presenter.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:use_cases/use_cases.dart';

import 'ingredients_editor_presenter_test.mocks.dart';

@GenerateMocks(<Type>[
  ExtractIngredientsUseCase,
  SaveIngredientsUseCase,
  SaveLanguageUseCase,
  GetLanguageUseCase,
])
void main() {
  late MockExtractIngredientsUseCase mockExtractIngredientsUseCase;
  late MockSaveIngredientsUseCase mockSaveIngredientsUseCase;
  late MockSaveLanguageUseCase mockSaveLanguageUseCase;
  late MockGetLanguageUseCase mockGetLanguageUseCase;
  late IngredientsEditorPresenter presenter;

  const Language testLanguage = Language.en;

  setUp(() {
    mockExtractIngredientsUseCase = MockExtractIngredientsUseCase();
    mockSaveIngredientsUseCase = MockSaveIngredientsUseCase();
    mockSaveLanguageUseCase = MockSaveLanguageUseCase();
    mockGetLanguageUseCase = MockGetLanguageUseCase();

    when(mockGetLanguageUseCase.call()).thenReturn(testLanguage);

    presenter = IngredientsEditorPresenter(
      mockSaveLanguageUseCase,
      mockExtractIngredientsUseCase,
      mockSaveIngredientsUseCase,
      mockGetLanguageUseCase,
    );
  });

  group('IngredientsEditorPresenter', () {
    const String testBarcode = '123456789';
    const String testImagePath = 'path/to/image.jpg';
    const String testIngredients = 'Water, Sugar, Salt';
    const ProductInfo testProductInfo = ProductInfo(barcode: testBarcode);
    const ProductPhoto testProductPhoto = ProductPhoto(
      path: testImagePath,
      info: testProductInfo,
    );

    blocTest<IngredientsEditorPresenter, IngredientsEditorViewModel>(
      'emits [IngredientsEditorLoadingState, IngredientsEditorExtractedState] '
      'when ExtractIngredientsEvent is added and succeeds',
      build: () {
        when(
          mockExtractIngredientsUseCase.call(testProductPhoto),
        ).thenAnswer((_) async => testIngredients);
        return presenter;
      },
      act: (IngredientsEditorPresenter bloc) =>
          bloc.add(const ExtractIngredientsEvent(testProductPhoto)),
      expect: () => <TypeMatcher<IngredientsEditorViewModel>>[
        isA<IngredientsEditorLoadingState>(),
        isA<IngredientsEditorExtractedState>().having(
          (IngredientsEditorExtractedState s) => s.ingredientsText,
          'ingredientsText',
          testIngredients,
        ),
      ],
    );

    blocTest<IngredientsEditorPresenter, IngredientsEditorViewModel>(
      'emits [IngredientsEditorLoadingState, IngredientsEditorErrorState] '
      'when ExtractIngredientsEvent fails',
      build: () {
        when(
          mockExtractIngredientsUseCase.call(testProductPhoto),
        ).thenThrow(Exception('OCR failed'));
        return presenter;
      },
      act: (IngredientsEditorPresenter bloc) =>
          bloc.add(const ExtractIngredientsEvent(testProductPhoto)),
      expect: () => <TypeMatcher<IngredientsEditorViewModel>>[
        isA<IngredientsEditorLoadingState>(),
        isA<IngredientsEditorErrorState>(),
      ],
    );

    blocTest<IngredientsEditorPresenter, IngredientsEditorViewModel>(
      'emits [IngredientsEditorLoadingState, IngredientsEditorSuccessState] '
      'when SaveIngredientsEvent is added and succeeds',
      build: () {
        when(
          mockSaveIngredientsUseCase.call(any),
        ).thenAnswer((Invocation _) async => <Object?, Object?>{});
        return presenter;
      },
      act: (IngredientsEditorPresenter bloc) => bloc.add(
        const SaveIngredientsEvent(
          barcode: testBarcode,
          ingredientsText: testIngredients,
        ),
      ),
      expect: () => <TypeMatcher<IngredientsEditorViewModel>>[
        isA<IngredientsEditorLoadingState>(),
        isA<IngredientsEditorSuccessState>(),
      ],
    );

    blocTest<IngredientsEditorPresenter, IngredientsEditorViewModel>(
      'emits [IngredientsEditorLoadingState, IngredientsEditorErrorState] '
      'when SaveIngredientsEvent fails',
      build: () {
        when(
          mockSaveIngredientsUseCase.call(any),
        ).thenThrow(Exception('Save failed'));
        return presenter;
      },
      act: (IngredientsEditorPresenter bloc) => bloc.add(
        const SaveIngredientsEvent(
          barcode: testBarcode,
          ingredientsText: testIngredients,
        ),
      ),
      expect: () => <TypeMatcher<IngredientsEditorViewModel>>[
        isA<IngredientsEditorLoadingState>(),
        isA<IngredientsEditorErrorState>(),
      ],
    );

    blocTest<IngredientsEditorPresenter, IngredientsEditorViewModel>(
      'updates language and emits new state when '
      'ChangeIngredientsLanguageEvent is added',
      build: () {
        when(mockSaveLanguageUseCase.call(any)).thenAnswer((_) async => true);
        return presenter;
      },
      act: (IngredientsEditorPresenter bloc) =>
          bloc.add(const ChangeIngredientsLanguageEvent(Language.uk)),
      expect: () => <TypeMatcher<IngredientsEditorViewModel>>[
        isA<IngredientsEditorInitialState>().having(
          (IngredientsEditorInitialState s) => s.language,
          'language',
          Language.uk,
        ),
      ],
    );
  });
}
