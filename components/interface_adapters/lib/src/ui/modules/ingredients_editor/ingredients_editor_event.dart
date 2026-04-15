import 'package:entities/entities.dart';

sealed class IngredientsEditorEvent {
  const IngredientsEditorEvent();
}

class ExtractIngredientsEvent extends IngredientsEditorEvent {
  const ExtractIngredientsEvent(this.productPhoto);

  final ProductPhoto productPhoto;
}

class SaveIngredientsEvent extends IngredientsEditorEvent {
  const SaveIngredientsEvent({
    required this.barcode,
    required this.ingredientsText,
  });

  final String barcode;
  final String ingredientsText;
}

class ChangeIngredientsLanguageEvent extends IngredientsEditorEvent {
  const ChangeIngredientsLanguageEvent(this.language);

  final Language language;
}

class IngredientsEditorBackEvent extends IngredientsEditorEvent {
  const IngredientsEditorBackEvent();
}
