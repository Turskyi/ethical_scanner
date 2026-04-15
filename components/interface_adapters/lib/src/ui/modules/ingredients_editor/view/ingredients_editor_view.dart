import 'dart:io';

import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_event.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_presenter.dart';
import 'package:interface_adapters/src/ui/modules/ingredients_editor/ingredients_editor_view_model.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/widgets/language_selector.dart';

class IngredientsEditorView extends StatefulWidget {
  const IngredientsEditorView({
    required this.productInfo,
    this.imagePath = '',
    super.key,
  });

  final ProductInfo productInfo;
  final String imagePath;

  @override
  State<IngredientsEditorView> createState() => _IngredientsEditorViewState();
}

class _IngredientsEditorViewState extends State<IngredientsEditorView> {
  final TextEditingController _ingredientsController = TextEditingController();
  final FocusNode _ingredientsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Trigger OCR automatically.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IngredientsEditorPresenter>().add(
          ExtractIngredientsEvent(
            ProductPhoto(path: widget.imagePath, info: widget.productInfo),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final IngredientsEditorViewModel viewModel = context
        .watch<IngredientsEditorPresenter>()
        .state;
    final Resources resources = Resources.of(context);
    final Gradients gradients = resources.gradients;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradients.violetTwilightGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            translate('photo.extract_ingredients'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            LanguageSelector(
              currentLanguage: viewModel.language,
              onLanguageSelected: (Language newLanguage) {
                context.read<IngredientsEditorPresenter>().add(
                  ChangeIngredientsLanguageEvent(newLanguage),
                );
              },
            ),
          ],
        ),
        // ignore: lines_longer_than_80_chars
        body: BlocConsumer<IngredientsEditorPresenter, IngredientsEditorViewModel>(
          listener: (BuildContext context, IngredientsEditorViewModel state) {
            if (state is IngredientsEditorExtractedState) {
              if (_ingredientsController.text != state.ingredientsText) {
                _ingredientsController.text = state.ingredientsText;
                // Move cursor to the end when text is updated from the state.
                _ingredientsController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _ingredientsController.text.length),
                );
              }
            } else if (state is IngredientsEditorSuccessState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(translate('save'))));
              Navigator.of(context).pop();
            }
          },
          builder: (BuildContext context, IngredientsEditorViewModel state) {
            if (state is IngredientsEditorLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state is IngredientsEditorErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<IngredientsEditorPresenter>().add(
                            ExtractIngredientsEvent(
                              ProductPhoto(
                                path: widget.imagePath,
                                info: widget.productInfo,
                              ),
                            ),
                          );
                        },
                        child: Text(translate('photo.extract_ingredients')),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is IngredientsEditorExtractedState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Image Preview
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildImagePreview(state),
                    ),
                    const SizedBox(height: 24),
                    // Text Editor
                    TextField(
                      controller: _ingredientsController,
                      focusNode: _ingredientsFocusNode,
                      maxLines: 12,
                      style: const TextStyle(color: Colors.white),
                      onTap: () {
                        // Explicitly request focus on tap to improve
                        // responsiveness on iPad.
                        _ingredientsFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        labelText: translate('product_info.ingredients'),
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        filled: true,
                        fillColor: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade900,
                      ),
                      onPressed: () {
                        context.read<IngredientsEditorPresenter>().add(
                          SaveIngredientsEvent(
                            barcode: widget.productInfo.barcode,
                            ingredientsText: _ingredientsController.text,
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: Text(
                        translate('save'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    _ingredientsFocusNode.dispose();
    super.dispose();
  }

  Widget _buildImagePreview(IngredientsEditorExtractedState state) {
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
