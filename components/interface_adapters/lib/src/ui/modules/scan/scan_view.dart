import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/scanner_error_widget.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_presenter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _HomeViewState();
}

class _HomeViewState extends State<ScanView> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final Rect scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Semantics(
        label: translate('scan.scan_screen'),
        child: AnimatedSwitcher(
          // Set the duration property
          duration: const Duration(milliseconds: 200),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              MobileScanner(
                controller: _scannerController,
                errorBuilder: (_, MobileScannerException error, __) {
                  _scannerController.stop().whenComplete(() {
                    _scannerController.start();
                  });
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.fitHeight,
                onDetect: _onBarcodeDetect,
                // scanWindow: scanWindow,
              ),
              CustomPaint(
                painter: ScannerOverlay(scanWindow),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => _closeCamera().whenComplete(() {
                        Navigator.pop(context);
                      }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ValueListenableBuilder<TorchState>(
                            valueListenable: _scannerController.torchState,
                            builder: (
                              BuildContext context,
                              TorchState value,
                              _,
                            ) {
                              final IconData iconData;
                              switch (value) {
                                case TorchState.off:
                                  iconData = Icons.flashlight_off;
                                  break;
                                case TorchState.on:
                                  iconData = Icons.flashlight_on;
                                  break;
                              }
        
                              return IconButton(
                                onPressed: _scannerController.toggleTorch,
                                icon: Icon(
                                  iconData,
                                  color: Colors.white,
                                ),
                              );
                            },
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

  Future<void> _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final Barcode barcode = barcodeCapture.barcodes.last;
    return _closeCamera().whenComplete(() {
      String? barcodeValue = barcode.displayValue ?? barcode.rawValue;
      if (barcodeValue != null) {
        context.read<ScanPresenter>().add(PopBarcodeEvent((barcodeValue)));
      } else {
        context.read<ScanPresenter>().add(const NavigateBackEvent());
      }
    });
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
      }
    });
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay(this.scanWindow);

  final Rect scanWindow;
  final double _borderRadius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object for the white border
    final Paint borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

// Create a Path object for the rounded corners
    final Path cornersPath = Path()
      // Start from the top left corner
      ..moveTo(
        scanWindow.left + _borderRadius,
        scanWindow.top,
      )
      ..lineTo(scanWindow.left + _borderRadius * 2, scanWindow.top)
      // Start from the top right corner
      ..moveTo(
        scanWindow.right - _borderRadius * 2,
        scanWindow.top,
      )
      // Move to the right
      ..lineTo(
        scanWindow.right - _borderRadius,
        scanWindow.top,
      )
      ..quadraticBezierTo(
        scanWindow.right, scanWindow.top, // Control point
        scanWindow.right, scanWindow.top + _borderRadius, // End point
      )
      // Move down
      ..lineTo(
        scanWindow.right,
        scanWindow.top + _borderRadius * 2,
      )
      ..moveTo(scanWindow.right, scanWindow.bottom - _borderRadius * 2)
      // Move down
      ..lineTo(scanWindow.right, scanWindow.bottom - _borderRadius)
      ..quadraticBezierTo(
        scanWindow.right, scanWindow.bottom, // Control point
        scanWindow.right - _borderRadius, scanWindow.bottom, // End point
      )
      ..lineTo(
        scanWindow.right - _borderRadius * 2,
        scanWindow.bottom,
      )
      ..moveTo(scanWindow.left + _borderRadius * 2, scanWindow.bottom)
      // Move to the left
      ..lineTo(
        scanWindow.left + _borderRadius,
        scanWindow.bottom,
      )
      ..quadraticBezierTo(
        scanWindow.left, scanWindow.bottom, // Control point
        scanWindow.left, scanWindow.bottom - _borderRadius, // End point
      )
      // Move up
      ..lineTo(
        scanWindow.left,
        scanWindow.bottom - _borderRadius * 2,
      )
      // Move to the starting point
      ..moveTo(
        scanWindow.left,
        scanWindow.top + _borderRadius * 2,
      )
      ..lineTo(scanWindow.left, scanWindow.top + _borderRadius)
      ..quadraticBezierTo(
        scanWindow.left, scanWindow.top, // Control point
        scanWindow.left + _borderRadius, scanWindow.top, // End point
      );

    // canvas.drawPath(backgroundWithCutout, backgroundPaint);
    // Draw the white rounded corners
    canvas.drawPath(cornersPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
