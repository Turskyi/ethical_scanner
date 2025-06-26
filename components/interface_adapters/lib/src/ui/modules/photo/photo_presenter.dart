import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/src/error_message_extractor.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_event.dart';
import 'package:use_cases/use_cases.dart';

part 'photo_view_model.dart';

class PhotoPresenter extends Bloc<PhotoEvent, PhotoViewModel> {
  PhotoPresenter(
    this._addIngredientsUseCase,
    this._saveLanguageUseCase,
    Language initialLanguage,
  ) : super(PhotoMakerReadyState(language: initialLanguage)) {
    on<PhotoViewBackEvent>(_onPhotoViewBack);

    on<TakePhotoEvent>(_onTakePhoto);

    on<TakenPhotoEvent>(_onTakenPhoto);

    on<RemovePhotoEvent>(_onRemovePhoto);

    on<AddIngredientsPhotoEvent>(_onAddIngredientsPhoto);

    on<ChangeLanguageEvent>(_changeLanguage);
  }

  final UseCase<Future<void>, ProductPhoto> _addIngredientsUseCase;
  final UseCase<Future<bool>, String> _saveLanguageUseCase;

  FutureOr<void> _onPhotoViewBack(
    PhotoViewBackEvent _,
    Emitter<PhotoViewModel> emit,
  ) {
    emit(CanceledPhotoState(language: state.language));
  }

  FutureOr<void> _onRemovePhoto(
    RemovePhotoEvent _,
    Emitter<PhotoViewModel> emit,
  ) {
    emit(PhotoMakerReadyState(language: state.language));
  }

  FutureOr<void> _onTakenPhoto(
    TakenPhotoEvent event,
    Emitter<PhotoViewModel> emit,
  ) {
    emit(TakenPhotoState(language: state.language, photoPath: event.imagePath));
  }

  FutureOr<void> _onTakePhoto(TakePhotoEvent _, Emitter<PhotoViewModel> emit) {
    emit(MakingPhotoState(language: state.language));
  }

  FutureOr<void> _onAddIngredientsPhoto(
    AddIngredientsPhotoEvent event,
    Emitter<PhotoViewModel> emit,
  ) async {
    try {
      emit(AddingIngredientsState(language: state.language));

      await _addIngredientsUseCase(event.productPhoto);
      emit(IngredientsAddedSuccessState(language: state.language));
    } on BackupUserForbiddenException catch (error, stacktrace) {
      emit(
        AddIngredientsErrorState(
          barcode: event.productPhoto.info.barcode,
          errorMessage: error.message,
          language: state.language,
        ),
      );
      debugPrint(
        'Caught BackupUserForbiddenException in _onAddIngredientsPhoto: $error',
      );
      debugPrint('Stacktrace for BackupUserForbiddenException:\n$stacktrace');
    } on ApiConnectionRefusedException catch (error, stacktrace) {
      emit(
        AddIngredientsErrorState(
          barcode: event.productPhoto.info.barcode,
          errorMessage: error.message,
          language: state.language,
        ),
      );
      debugPrint(
        'Caught ApiConnectionRefusedException in _onAddIngredientsPhoto: '
        '$error',
      );
      debugPrint('Stacktrace for ApiConnectionRefusedException:\n$stacktrace');
    } on BadRequestError catch (error, stacktrace) {
      emit(
        AddIngredientsErrorState(
          barcode: event.productPhoto.info.barcode,
          errorMessage: extractErrorMessage(error.message),
          language: state.language,
        ),
      );
      debugPrint('Caught BadRequestError: $error\n$stacktrace');
    } catch (error, stacktrace) {
      emit(
        AddIngredientsErrorState(
          language: state.language,
          barcode: event.productPhoto.info.barcode,
          errorMessage: error is BadRequestError
              ? extractErrorMessage(error.message)
              : error.toString(),
        ),
      );
      debugPrint('Caught general error: $error\n$stacktrace');
    }
  }

  FutureOr<void> _changeLanguage(
    ChangeLanguageEvent event,
    Emitter<PhotoViewModel> emit,
  ) async {
    final Language language = event.language;
    if (language != state.language) {
      final bool isSaved = await _saveLanguageUseCase.call(
        language.isoLanguageCode,
      );
      if (isSaved && state is PhotoMakerReadyState) {
        emit((state as PhotoMakerReadyState).copyWith(language: language));
      } else {
        emit(PhotoMakerReadyState(language: state.language));
      }
    }
  }
}
