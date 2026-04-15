import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_event.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_view_model.dart';
import 'package:use_cases/use_cases.dart';

class IngredientsEditorPresenter
    extends Bloc<IngredientsEditorEvent, IngredientsEditorViewModel> {
  IngredientsEditorPresenter(
    this._saveLanguageUseCase,
    this._extractIngredientsUseCase,
    this._saveIngredientsUseCase,
    UseCase<Language, Object?> _getLanguageUseCase,
  ) : super(
        IngredientsEditorInitialState(language: _getLanguageUseCase.call()),
      ) {
    on<ExtractIngredientsEvent>(_onExtractIngredients);
    on<SaveIngredientsEvent>(_onSaveIngredients);
    on<ChangeIngredientsLanguageEvent>(_onChangeLanguage);
    on<IngredientsEditorBackEvent>(_onBack);
  }

  final UseCase<Future<bool>, String> _saveLanguageUseCase;
  final UseCase<Future<String>, ProductPhoto> _extractIngredientsUseCase;
  final UseCase<Future<void>, SaveIngredientsParams> _saveIngredientsUseCase;

  FutureOr<void> _onExtractIngredients(
    ExtractIngredientsEvent event,
    Emitter<IngredientsEditorViewModel> emit,
  ) async {
    try {
      emit(IngredientsEditorLoadingState(language: state.language));

      final String ingredientsText = await _extractIngredientsUseCase(
        event.productPhoto,
      );

      emit(
        IngredientsEditorExtractedState(
          language: state.language,
          ingredientsText: ingredientsText,
          imagePath: event.productPhoto.path,
          imageUrl: event.productPhoto.info.imageIngredientsUrl,
        ),
      );
    } catch (error, stacktrace) {
      emit(
        IngredientsEditorErrorState(
          language: state.language,
          errorMessage: error.toString(),
        ),
      );
      debugPrint('Error in _onExtractIngredients: $error\n$stacktrace');
    }
  }

  FutureOr<void> _onSaveIngredients(
    SaveIngredientsEvent event,
    Emitter<IngredientsEditorViewModel> emit,
  ) async {
    try {
      emit(IngredientsEditorLoadingState(language: state.language));

      await _saveIngredientsUseCase(
        SaveIngredientsParams(
          barcode: event.barcode,
          ingredientsText: event.ingredientsText,
          language: state.language,
        ),
      );

      emit(IngredientsEditorSuccessState(language: state.language));
    } catch (error, stacktrace) {
      emit(
        IngredientsEditorErrorState(
          language: state.language,
          errorMessage: error.toString(),
        ),
      );
      debugPrint('Error in _onSaveIngredients: $error\n$stacktrace');
    }
  }

  FutureOr<void> _onChangeLanguage(
    ChangeIngredientsLanguageEvent event,
    Emitter<IngredientsEditorViewModel> emit,
  ) async {
    final Language language = event.language;
    if (language != state.language) {
      await _saveLanguageUseCase.call(language.isoLanguageCode);
      // We don't necessarily need to emit a new state here if the UI
      // reacts to the language change via other means, but for consistency:
      if (state is IngredientsEditorExtractedState) {
        final IngredientsEditorExtractedState currentState =
            state as IngredientsEditorExtractedState;
        emit(
          IngredientsEditorExtractedState(
            language: language,
            ingredientsText: currentState.ingredientsText,
            imagePath: currentState.imagePath,
            imageUrl: currentState.imageUrl,
          ),
        );
      } else if (state is IngredientsEditorInitialState) {
        emit(IngredientsEditorInitialState(language: language));
      }
    }
  }

  FutureOr<void> _onBack(
    IngredientsEditorBackEvent event,
    Emitter<IngredientsEditorViewModel> emit,
  ) {
    // This state can be used by the router to pop the screen.
    // For simplicity, we might just handle the back button in the View.
  }
}
