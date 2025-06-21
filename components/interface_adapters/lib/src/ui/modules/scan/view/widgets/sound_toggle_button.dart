import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_adapters/interface_adapters.dart';

class SoundToggleButton extends StatelessWidget {
  const SoundToggleButton({required this.listener, super.key});

  /// Takes the `BuildContext` along with the [bloc] `state`
  /// and is responsible for executing in response to `state` changes.
  final BlocWidgetListener<ScanViewModel> listener;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: BlocConsumer<ScanPresenter, ScanViewModel>(
        listener: listener,
        builder: (
          _,
          ScanViewModel viewModel,
        ) {
          if (kIsWeb || Platform.isMacOS) {
            return const SizedBox.shrink();
          } else {
            return Icon(
              viewModel.isScanningWithSound
                  ? Icons.music_note_outlined
                  : Icons.music_off_outlined,
              color: Colors.white,
            );
          }
        },
      ),
      onPressed: () =>
          context.read<ScanPresenter>().add(const SoundToggleEvent()),
    );
  }
}
