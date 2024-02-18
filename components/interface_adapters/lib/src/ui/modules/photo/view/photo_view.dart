import 'dart:io';

import 'package:camera/camera.dart';
import 'package:entities/entities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_event.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_presenter.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart'
    as constants;
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({
    super.key,
    required this.productInfo,
    required this.cameraDescriptions,
  });

  final ProductInfo productInfo;
  final List<CameraDescription> cameraDescriptions;

  @override
  State<PhotoView> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<PhotoView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final RegExp _emailExp = RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,}\b');
  double _currentZoomLevel = 1.0; // Initial zoom level
  double _maxZoomLevel = 5.0; // Initial max zoom level
  final double _zoomStep = 0.4; // Adjust the step size as needed

  @override
  void initState() {
    super.initState();
    if (widget.cameraDescriptions.isNotEmpty) {
      _controller = CameraController(
        widget.cameraDescriptions.first,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize().then((_) {
        // The returned value in `then` is always `null`
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              break;
            default:
              break;
          }
        }
      });
    } else {
      throw Exception('No cameras available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = Resources.of(context);
    Dimens dimens = resources.dimens;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: resources.gradients.violetTwilightGradient,
      ),
      child: Scaffold(
        // We need to set transparent background explicitly, because
        // Scaffold does not support gradient backgrounds, so we program it
        // to remove any default background, so that the custom background
        // above will be visible.
        backgroundColor: Colors.transparent,
        // `extendBodyBehindAppBar: true` and
        // `appBar` `backgroundColor: Colors.transparent` makes appbar with
        // background color.
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<PhotoPresenter>().add(const PhotoViewBackEvent());
            },
          ),
          title: Text(
            translate('photo.capture_ingredients'),
            textAlign: TextAlign.center,
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
            textScaler: const TextScaler.linear(1.2),
          ),
        ),
        body: BlocBuilder<PhotoPresenter, PhotoViewModel>(
          builder: (BuildContext context, PhotoViewModel viewModel) {
            CameraValue camera = _controller.value;
            // fetch screen size
            final Size size = MediaQuery.of(context).size;

            // Calculate scale depending on screen and camera ratios
            // this is actually size.aspectRatio / (1 / camera.aspectRatio)
            // because camera preview size is received as landscape
            // but we're calculating for portrait orientation.
            double scale = size.aspectRatio *
                (camera.isInitialized ? camera.aspectRatio : 1.0);

            // to prevent scaling down, invert the value
            if (scale < 1) scale = 1 / scale;

            if (camera.isInitialized) {
              _controller.setFlashMode(FlashMode.off);
              _controller.getMaxZoomLevel().then((double max) {
                _maxZoomLevel = max;
              });
              _controller.setFocusMode(FocusMode.auto);
            }

            return Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onScaleUpdate: (ScaleUpdateDetails details) {
                        double newZoomLevel = _currentZoomLevel * details.scale;
                        newZoomLevel = newZoomLevel.clamp(1.0, _maxZoomLevel);
                        _controller.setZoomLevel(newZoomLevel);
                        setState(() {
                          _currentZoomLevel = newZoomLevel;
                        });
                      },
                      child: CameraPreview(_controller),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: AnimatedOpacity(
                        opacity: viewModel is TakenPhotoState ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        // Display captured photo preview
                        child: viewModel is TakenPhotoState
                            ? GestureDetector(
                                onTap: () {
                                  // Remove the preview and reset the captured
                                  // image path.
                                  context
                                      .read<PhotoPresenter>()
                                      .add(const RemovePhotoEvent());
                                },
                                child: Container(
                                  width: 200.0, // Increased width
                                  height: 350, // Increased height
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.file(
                                        File(viewModel.photoPath),
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          color: Colors.black.withOpacity(0.5),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    if (viewModel is LoadingState)
                      const CircularProgressIndicator(color: Colors.white),
                    if (viewModel is AddIngredientsErrorState)
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.black.withOpacity(0.7),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(
                              ClipboardData(text: viewModel.errorMessage),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  translate('copied_to_clipboard'),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            strutStyle: StrutStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                            ),
                            text: _getTextSpan(
                              viewModel.errorMessage,
                              Theme.of(context).textTheme.bodyLarge?.fontSize,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Buttons for manual zoom control
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        // Decrease zoom
                        onPressed: () => _adjustZoomLevel(-_zoomStep),
                        child: const Icon(Icons.remove),
                      ),
                      ElevatedButton(
                        // Increase zoom
                        onPressed: () => _adjustZoomLevel(_zoomStep),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<PhotoPresenter, PhotoViewModel>(
          builder: (BuildContext context, PhotoViewModel viewModel) {
            return viewModel is AddIngredientsErrorState
                ? const SizedBox()
                : FloatingActionButton(
                    onPressed: viewModel is LoadingState
                        ? null
                        : viewModel is TakenPhotoState
                            ? () {
                                context.read<PhotoPresenter>().add(
                                      AddIngredientsPhotoEvent(
                                        ProductPhoto(
                                          path: viewModel.photoPath,
                                          info: widget.productInfo,
                                        ),
                                      ),
                                    );
                              }
                            : () async {
                                context
                                    .read<PhotoPresenter>()
                                    .add(const TakePhotoEvent());
                                try {
                                  await _initializeControllerFuture;

                                  // Take a picture and get the file path
                                  XFile picture =
                                      await _controller.takePicture();

                                  if (context.mounted) {
                                    context
                                        .read<PhotoPresenter>()
                                        .add(TakenPhotoEvent(picture.path));
                                  } else {
                                    //TODO: add error event
                                  }
                                } catch (e) {
                                  debugPrint('Error taking picture: $e');
                                }
                              },
                    child: viewModel is TakenPhotoState
                        ? const Icon(Icons.send)
                        : viewModel is PhotoMakerReadyState ||
                                viewModel is AddIngredientsErrorState
                            ? const Icon(Icons.camera)
                            : viewModel is LoadingState
                                ? const Icon(Icons.stop)
                                : const SizedBox(),
                  );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _adjustZoomLevel(double delta) {
    double newZoomLevel = (_currentZoomLevel + delta).clamp(1.0, _maxZoomLevel);
    _controller.setZoomLevel(newZoomLevel);
    setState(() {
      _currentZoomLevel = newZoomLevel;
    });
  }

  TextSpan _getTextSpan(String text, double? fontSize) {
    final Iterable<Match> matches = _emailExp.allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      );
    }

    final List<TextSpan> spans = <TextSpan>[];
    int start = 0;

    for (final Match match in matches) {
      if (match.start != start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        );
      }

      final String? email = match.group(0);
      spans.add(
        TextSpan(
          text: email,
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri emailLaunchUri = Uri(
                scheme: constants.mailToScheme,
                path: email,
              );

              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                throw PlatformException(
                  code: 'UNABLE_TO_LAUNCH_URL',
                  message: 'Could not launch $emailLaunchUri',
                );
              }
            },
        ),
      );

      start = match.end;
    }

    if (start != text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
