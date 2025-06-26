part of 'photo_presenter.dart';

sealed class PhotoViewModel {
  const PhotoViewModel({required this.language});

  final Language language;
}

abstract class LoadingState extends PhotoViewModel {
  const LoadingState({required super.language});
}

class PhotoMakerReadyState extends PhotoViewModel {
  const PhotoMakerReadyState({required super.language});

  PhotoMakerReadyState copyWith({
    Language? language,
  }) {
    return PhotoMakerReadyState(
      language: language ?? this.language,
    );
  }
}

class MakingPhotoState extends LoadingState {
  const MakingPhotoState({required super.language});
}

class TakenPhotoState extends PhotoViewModel {
  const TakenPhotoState({required super.language, required this.photoPath});

  final String photoPath;
}

class IngredientsAddedSuccessState extends PhotoViewModel {
  const IngredientsAddedSuccessState({required super.language});
}

class CanceledPhotoState extends PhotoViewModel {
  const CanceledPhotoState({required super.language});
}

class AddIngredientsErrorState extends PhotoViewModel {
  const AddIngredientsErrorState({
    required String barcode,
    required this.errorMessage,
    required super.language,
  });

  final String errorMessage;
}

class AddingIngredientsState extends LoadingState {
  const AddingIngredientsState({required super.language});
}
