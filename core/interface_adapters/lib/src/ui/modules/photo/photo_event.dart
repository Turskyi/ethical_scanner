import 'package:entities/entities.dart';

sealed class PhotoEvent {
  const PhotoEvent();
}

class AddIngredientsPhotoEvent extends PhotoEvent {
  const AddIngredientsPhotoEvent(this.productPhoto);
  final ProductPhoto productPhoto;
}

class PhotoViewBackEvent extends PhotoEvent {
  const PhotoViewBackEvent();
}

class TakePhotoEvent extends PhotoEvent {
  const TakePhotoEvent();
}

class TakenPhotoEvent extends PhotoEvent {
  const TakenPhotoEvent(this.imagePath);
  final String imagePath;
}

class RemovePhotoEvent extends PhotoEvent {
  const RemovePhotoEvent();
}
