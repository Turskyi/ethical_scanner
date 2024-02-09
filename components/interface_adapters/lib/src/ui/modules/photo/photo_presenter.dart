import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_event.dart';
import 'package:use_cases/use_cases.dart';

part 'photo_view_model.dart';

class PhotoPresenter extends Bloc<PhotoEvent, PhotoViewModel> {
  PhotoPresenter(this._addIngredientsUseCase)
      : super(const PhotoMakerReadyState()) {
    on<PhotoViewBackEvent>(
      (PhotoViewBackEvent event, Emitter<PhotoViewModel> emit) {
        emit(const CanceledPhotoState());
      },
    );
    on<TakePhotoEvent>(
      (TakePhotoEvent event, Emitter<PhotoViewModel> emit) =>
          emit(const MakingPhotoState()),
    );
    on<TakenPhotoEvent>(
      (TakenPhotoEvent event, Emitter<PhotoViewModel> emit) =>
          emit(TakenPhotoState(event.imagePath)),
    );
    on<RemovePhotoEvent>(
      (_, Emitter<PhotoViewModel> emit) {
        emit(const PhotoMakerReadyState());
      },
    );
    on<AddIngredientsPhotoEvent>(
        (AddIngredientsPhotoEvent event, Emitter<PhotoViewModel> emit) async {
      try {
        emit(const AddingIngredientsState());
        await _addIngredientsUseCase(event.productPhoto);
        emit(const IngredientsAddedSuccessState());
      } catch (error, stacktrace) {
        emit(
          AddIngredientsErrorState(
            barcode: event.productPhoto.info.barcode,
            errorMessage: error.toString(),
          ),
        );
        debugPrint('Stacktrace: $stacktrace');
      }
    });
  }

  final UseCase<Future<void>, ProductPhoto> _addIngredientsUseCase;
}
