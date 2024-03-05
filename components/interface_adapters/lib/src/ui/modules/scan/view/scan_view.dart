import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/scanner_error_widget.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_presenter.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/scan_placeholder_widget.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/scanner_overlay.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart'
    as constants;
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
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
    Resources resources = Resources.of(context);
    Dimens dimens = resources.dimens;
    EdgeInsets paddingTop = EdgeInsets.only(
      top: MediaQuery.paddingOf(context).top,
      left: dimens.leftPadding,
    );
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
                errorBuilder: (_, MobileScannerException error, __) {
                  _scannerController.stop().whenComplete(() {
                    _scannerController
                        .start()
                        .catchError((Object error, StackTrace stacktrace) {
                      debugPrint(
                          'Warning: an error occurred in $runtimeType: $error\n'
                          'Stacktrace: $stacktrace');
                      throw const NotFoundException(
                        'No camera found or failed to open camera!',
                      );
                    });
                  });
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.fitHeight,
                onDetect: _onBarcodeDetect,
                placeholderBuilder: (_, __) => const ScanPlaceholderWidget(),
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
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => _closeCamera().whenComplete(() {
                            context
                                .read<ScanPresenter>()
                                .add(const NavigateBackEvent());
                          }),
                        ),
                        IconButton(
                          icon: BlocConsumer<ScanPresenter, ScanViewModel>(
                            listener: (
                              BuildContext context,
                              ScanViewModel viewModel,
                            ) {
                              if (viewModel is DetectedBarcodeState) {
                                if (viewModel.isSoundOn) {
                                  // Play a sound as a one-shot, releasing its
                                  // resources when it finishes playing.
                                  Audio.load(constants.scanSoundAsset)
                                    ..play()
                                    ..dispose();
                                }
                                _closeCamera().whenComplete(() {
                                  context.read<ScanPresenter>().add(
                                        PopBarcodeEvent(viewModel.barcodeValue),
                                      );
                                });
                              }
                            },
                            builder: (
                              _,
                              ScanViewModel viewModel,
                            ) =>
                                Icon(
                              viewModel is ScanningState && viewModel.isSoundOn
                                  ? Icons.music_note_outlined
                                  : Icons.music_off_outlined,
                              color: Colors.white,
                            ),
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
                          ValueListenableBuilder<TorchState>(
                            valueListenable: _scannerController.torchState,
                            builder: (_, TorchState torchState, __) =>
                                IconButton(
                              onPressed: _scannerController.toggleTorch,
                              icon: Icon(
                                torchState == TorchState.on
                                    ? Icons.flashlight_on
                                    : Icons.flashlight_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
    _scannerController.dispose();
    super.dispose();
  }

  void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final Barcode barcode = barcodeCapture.barcodes.last;
    String? barcodeValue = barcode.displayValue ?? barcode.rawValue;
    return context
        .read<ScanPresenter>()
        .add(DetectedBarcodeEvent(barcodeValue));
  }

  Future<void> _closeCamera() => _scannerController.stop().catchError((
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
          debugPrint('Error in $runtimeType: $error.'
              '\nStacktrace: $stackTrace');
        }
      });
}
