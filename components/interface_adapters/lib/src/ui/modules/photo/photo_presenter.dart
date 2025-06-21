import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/src/error_message_extractor.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_event.dart';
import 'package:use_cases/use_cases.dart';

part 'photo_view_model.dart';

class PhotoPresenter extends Bloc<PhotoEvent, PhotoViewModel> {
  PhotoPresenter(this._addIngredientsUseCase)
      : super(const PhotoMakerReadyState()) {
    on<PhotoViewBackEvent>(_onPhotoViewBack);

    on<TakePhotoEvent>(_onTakePhoto);

    on<TakenPhotoEvent>(_onTakenPhoto);

    on<RemovePhotoEvent>(_onRemovePhoto);

    on<AddIngredientsPhotoEvent>(_onAddIngredientsPhoto);
  }

  final UseCase<Future<void>, ProductPhoto> _addIngredientsUseCase;

  FutureOr<void> _onPhotoViewBack(
    PhotoViewBackEvent _,
    Emitter<PhotoViewModel> emit,
  ) {
    emit(const CanceledPhotoState());
  }

  FutureOr<void> _onRemovePhoto(
    RemovePhotoEvent _,
    Emitter<PhotoViewModel> emit,
  ) {
    emit(const PhotoMakerReadyState());
  }

  FutureOr<void> _onTakenPhoto(
    TakenPhotoEvent event,
    Emitter<PhotoViewModel> emit,
  ) {
    emit(TakenPhotoState(event.imagePath));
  }

  FutureOr<void> _onTakePhoto(TakePhotoEvent _, Emitter<PhotoViewModel> emit) {
    emit(const MakingPhotoState());
  }

  FutureOr<void> _onAddIngredientsPhoto(
    AddIngredientsPhotoEvent event,
    Emitter<PhotoViewModel> emit,
  ) async {
    try {
      emit(const AddingIngredientsState());

      await _addIngredientsUseCase(event.productPhoto);
      emit(const IngredientsAddedSuccessState());
    } on BackupUserForbiddenException catch (error, stacktrace) {
      emit(
        AddIngredientsErrorState(
          barcode: event.productPhoto.info.barcode,
          errorMessage: error.message,
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
        ),
      );
      debugPrint('Caught BadRequestError: $error\n$stacktrace');
    } catch (error, stacktrace) {
      emit(
        AddIngredientsErrorState(
          barcode: event.productPhoto.info.barcode,
          errorMessage: error is BadRequestError
              ? extractErrorMessage(error.message)
              : error.toString(),
        ),
      );
      debugPrint('Caught general error: $error\n$stacktrace');
    }
  }
}
