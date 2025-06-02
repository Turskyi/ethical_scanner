import 'dart:async';
import 'dart:io';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/scanner_error_widget.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_presenter.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/scan_placeholder_widget.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/scanner_overlay.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
import 'package:interface_adapters/src/ui/res/widgets/leading_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _HomeViewState();
}

class _HomeViewState extends State<ScanView> {
  final double _scanWindowSize = 200.0;

  /// Adjust the bottom padding
  final double _bottomPadding = 32.0;
  final MobileScannerController _scannerController = MobileScannerController();
  late Rect _scanWindow;

  @override
  void didChangeDependencies() {
    _scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: _scanWindowSize,
      height: _scanWindowSize,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final Dimens dimens = resources.dimens;
    final EdgeInsets paddingTop = EdgeInsets.only(
      top: MediaQuery.paddingOf(context).top,
      left: dimens.leftPadding,
    );

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isWide = screenWidth > kWideScreenThreshold;
    final BoxFit currentFit =
        (isWide && kIsWeb) ? BoxFit.fitWidth : BoxFit.fitHeight;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Semantics(
        label: translate('scan.scan_screen'),
        // During scenarios where something dynamically changes the child
        // widgets within the `Stack`, the `AnimatedSwitcher` will animate the
        // transition between them.
        child: AnimatedSwitcher(
          duration: resources.durations.animatedSwitcher,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              MobileScanner(
                controller: _scannerController,
                errorBuilder: (_, MobileScannerException error) {
                  _restartScannerOnError();
                  return ScannerErrorWidget(error: error);
                },
                fit: currentFit,
                onDetect: _onBarcodeDetect,
                placeholderBuilder: (_) => const ScanPlaceholderWidget(),
              ),
              CustomPaint(painter: ScannerOverlay(_scanWindow)),
              Padding(
                padding: paddingTop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        kIsWeb
                            ? LeadingWidget(
                                logoPath:
                                    '${kImagesPath}ethical_scanner_logo.jpeg',
                                onTap: _onBackPressed,
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: _onBackPressed,
                              ),
                        IconButton(
                          icon: BlocConsumer<ScanPresenter, ScanViewModel>(
                            listener: _viewModelListener,
                            builder: (
                              _,
                              ScanViewModel viewModel,
                            ) {
                              if (kIsWeb || Platform.isMacOS) {
                                return const SizedBox.shrink();
                              } else {
                                return Icon(
                                  viewModel is ScanningState &&
                                          viewModel.isSoundOn
                                      ? Icons.music_note_outlined
                                      : Icons.music_off_outlined,
                                  color: Colors.white,
                                );
                              }
                            },
                          ),
                          onPressed: () => context
                              .read<ScanPresenter>()
                              .add(const SoundToggleEvent()),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: _bottomPadding),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ValueListenableBuilder<MobileScannerState>(
                            valueListenable: _scannerController,
                            builder: (_, MobileScannerState scannerState, __) {
                              if (!scannerState.isInitialized ||
                                  !scannerState.isRunning) {
                                return const SizedBox.shrink();
                              }

                              switch (scannerState.torchState) {
                                case TorchState.auto:
                                  return IconButton(
                                    color: Colors.white,
                                    iconSize: 32.0,
                                    icon: const Icon(Icons.flash_auto),
                                    onPressed: () async {
                                      await _scannerController.toggleTorch();
                                    },
                                  );
                                case TorchState.off:
                                  return IconButton(
                                    color: Colors.white,
                                    iconSize: 32.0,
                                    icon: const Icon(Icons.flash_off),
                                    onPressed: () async {
                                      await _scannerController.toggleTorch();
                                    },
                                  );
                                case TorchState.on:
                                  return IconButton(
                                    color: Colors.white,
                                    iconSize: 32.0,
                                    icon: const Icon(Icons.flash_on),
                                    onPressed: () async {
                                      await _scannerController.toggleTorch();
                                    },
                                  );
                                case TorchState.unavailable:
                                  return const Icon(
                                    Icons.no_flash,
                                    color: Colors.grey,
                                  );
                              }
                            },
                          ),
                          if (!kIsWeb && !Platform.isMacOS)
                            IconButton(
                              onPressed: _scannerController.switchCamera,
                              icon: const Icon(
                                Icons.cameraswitch_rounded,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: paddingTop,
                child: Text(
                  translate('title'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        blurRadius: Resources.of(context).dimens.bodyBlurRadius,
                        color: Colors.white30,
                        offset: Offset(
                          dimens.bodyTitleOffset,
                          dimens.bodyTitleOffset,
                        ),
                      ),
                    ],
                  ),
                  textScaler: const TextScaler.linear(1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    _scannerController.dispose();
  }

  void _restartScannerOnError() {
    _scannerController.stop().whenComplete(() {
      _scannerController
          .start()
          .catchError((Object error, StackTrace stacktrace) {
        debugPrint(
          'Warning: an error occurred in $runtimeType: $error\n'
          'Stacktrace: $stacktrace',
        );
        throw const NotFoundException(
          'No camera found or failed to open camera!',
        );
      });
    });
  }

  void _onBackPressed() {
    _closeCamera().whenComplete(() {
      if (mounted) {
        context.read<ScanPresenter>().add(const NavigateBackEvent());
      }
    });
  }

  void _viewModelListener(
    BuildContext context,
    ScanViewModel viewModel,
  ) {
    if (viewModel is DetectedBarcodeState) {
      if (!kIsWeb && !Platform.isMacOS && viewModel.isSoundOn) {
        // Play a sound as a one-shot, releasing its
        // resources when it finishes playing.
        Audio.load(kScanSoundAsset)
          ..play()
          ..dispose();
      }
      _closeCamera().whenComplete(() {
        if (context.mounted) {
          context.read<ScanPresenter>().add(
                PopBarcodeEvent(
                  viewModel.barcodeValue,
                ),
              );
        }
      });
    }
  }

  void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final Barcode? barcode = barcodeCapture.barcodes.lastOrNull;
    final String barcodeValue =
        barcode?.displayValue ?? barcode?.rawValue ?? '';

    if (barcodeValue.isEmpty) {
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to read barcode on web. This may be a known issue. Try '
              'adjusting the barcode position or use a different device.',
            ),
          ),
        );
      } else {
        // Mobile — shouldn't happen often, but still fallback.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No valid barcode detected. Please try again.'),
          ),
        );
      }
    } else {
      context.read<ScanPresenter>().add(DetectedBarcodeEvent(barcodeValue));
    }
  }

  Future<void> _closeCamera() {
    return _scannerController.stop().catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong! $error'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        debugPrint(
          'Error in $runtimeType: $error.'
          '\nStacktrace: $stackTrace',
        );
      }
    });
  }
}
