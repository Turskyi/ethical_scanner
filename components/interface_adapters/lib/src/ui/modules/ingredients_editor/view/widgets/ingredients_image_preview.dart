import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_view_model.dart';

class IngredientsImagePreview extends StatelessWidget {
  const IngredientsImagePreview({required this.state, super.key});

  final IngredientsEditorExtractedState state;

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (state.imagePath.isNotEmpty) {
      if (kIsWeb) {
        image = Image.network(state.imagePath);
      } else {
        image = Image.file(File(state.imagePath));
      }
    } else if (state.imageUrl.isNotEmpty) {
      image = Image.network(state.imageUrl);
    } else {
      return const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white24, size: 48),
      );
    }

    return InteractiveViewer(
      clipBehavior: Clip.none,
      minScale: 1.0,
      maxScale: 4.0,
      child: Center(child: image),
    );
  }
}
