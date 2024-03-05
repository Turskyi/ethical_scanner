part of 'photo_presenter.dart';

sealed class PhotoViewModel {
  const PhotoViewModel();
}

abstract class LoadingState extends PhotoViewModel {
  const LoadingState();
}

class PhotoMakerReadyState extends PhotoViewModel {
  const PhotoMakerReadyState();
}

class MakingPhotoState extends LoadingState {
  const MakingPhotoState();
}

class TakenPhotoState extends PhotoViewModel {
  const TakenPhotoState(this.photoPath);
  final String photoPath;
}

class IngredientsAddedSuccessState extends PhotoViewModel {
  const IngredientsAddedSuccessState();
}

class CanceledPhotoState extends PhotoViewModel {
  const CanceledPhotoState();
}

class AddIngredientsErrorState extends PhotoViewModel {
  const AddIngredientsErrorState({
    required String barcode,
    required this.errorMessage,
  }) : super();
  final String errorMessage;
}

class AddingIngredientsState extends LoadingState {
  const AddingIngredientsState();
}
