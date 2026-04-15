import 'package:entities/entities.dart';

sealed class IngredientsEditorViewModel {
  const IngredientsEditorViewModel({required this.language});

  final Language language;
}

class IngredientsEditorInitialState extends IngredientsEditorViewModel {
  const IngredientsEditorInitialState({required super.language});
}

class IngredientsEditorLoadingState extends IngredientsEditorViewModel {
  const IngredientsEditorLoadingState({required super.language});
}

class IngredientsEditorExtractedState extends IngredientsEditorViewModel {
  const IngredientsEditorExtractedState({
    required super.language,
    required this.ingredientsText,
    required this.imagePath,
    required this.imageUrl,
  });

  final String ingredientsText;
  final String imagePath;
  final String imageUrl;
}

class IngredientsEditorSuccessState extends IngredientsEditorViewModel {
  const IngredientsEditorSuccessState({required super.language});
}

class IngredientsEditorErrorState extends IngredientsEditorViewModel {
  const IngredientsEditorErrorState({
    required super.language,
    required this.errorMessage,
  });

  final String errorMessage;
}
