import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/widgets/language_selector.dart';

class WebLanguageSelector extends StatelessWidget {
  const WebLanguageSelector({required this.onLanguageChanged, super.key});

  final VoidCallback onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanPresenter, ScanViewModel>(
      builder: (BuildContext context, ScanViewModel viewModel) {
        return LanguageSelector(
          currentLanguage: viewModel.language,
          onLanguageSelected: (Language newLanguage) {
            // Dispatch event to the presenter to handle
            // language change logic and update its
            // state (which might also update this
            // screen's language).
            context.read<ScanPresenter>().add(
              ChangeScanLanguageEvent(newLanguage),
            );
            onLanguageChanged.call();
          },
        );
      },
    );
  }
}
