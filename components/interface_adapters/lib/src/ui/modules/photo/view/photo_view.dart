import 'dart:io';

import 'package:camera/camera.dart';
import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_event.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_presenter.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({
    required this.productInfo,
    required this.cameraDescriptions,
    super.key,
  });

  final ProductInfo productInfo;
  final List<CameraDescription> cameraDescriptions;

  @override
  State<PhotoView> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<PhotoView> {
  final double _zoomStep = 0.4;
  final RegExp _emailExp = RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,}\b');

  final RegExp _urlExp = RegExp(
    r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    caseSensitive: false,
  );

  // Initial zoom level.
  double _currentZoomLevel = 1.0;

  /// Initial max zoom level.
  double _maxZoomLevel = 5.0;

  bool _noCameraAvailable = false;

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.cameraDescriptions.isNotEmpty) {
      _controller = CameraController(
        widget.cameraDescriptions.first,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller?.initialize().then((_) {
        // The returned value in `then` is always `null`
        if (!mounted) {
          return;
        }
        _configureCamera();
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
      _noCameraAvailable = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final Dimens dimens = resources.dimens;
    if (_noCameraAvailable) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: resources.gradients.unauthorizedConstructionGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                    blurRadius: dimens.bodyBlurRadius,
                    color: Colors.white30,
                    offset: Offset(
                      dimens.bodyTitleOffset,
                      dimens.bodyTitleOffset,
                    ),
                  ),
                ],
              ),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Camera access is not supported on this device.\n\n'
                          'This feature is available on Web, Android, and iOS '
                          'platforms.\n\nPlease try scanning the product using '
                          'another device,\nor visit:\n',
                    ),
                    TextSpan(
                      text: kDomain,
                      style: const TextStyle(
                        color: Colors.lightBlueAccent,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri url = Uri.parse(kWebsite);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

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
            maxLines: 2,
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
            final CameraValue? camera = _controller?.value;
            if (camera == null) {
              return const Center(child: SizedBox.shrink());
            }
            // Fetch screen size.
            final Size size = MediaQuery.sizeOf(context);

            // Calculate scale depending on screen and camera ratios
            // this is actually size.aspectRatio / (1 / camera.aspectRatio)
            // because camera preview size is received as landscape
            // but we're calculating for portrait orientation.
            double scale = size.aspectRatio *
                (camera.isInitialized ? camera.aspectRatio : 1.0);

            // to prevent scaling down, invert the value
            if (scale < 1) scale = 1 / scale;
            final double? bodyLargeFontSize =
                Theme.of(context).textTheme.bodyLarge?.fontSize;
            final Stack cameraStack = Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                GestureDetector(
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    double newZoomLevel = _currentZoomLevel * details.scale;
                    newZoomLevel = newZoomLevel.clamp(1.0, _maxZoomLevel);
                    if (!kIsWeb) {
                      _controller?.setZoomLevel(newZoomLevel);
                    }
                    setState(() {
                      _currentZoomLevel = newZoomLevel;
                    });
                  },
                  child: _controller != null
                      ? CameraPreview(_controller!)
                      : const SizedBox(),
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
                                  if (kIsWeb)
                                    Image.network(
                                      viewModel.photoPath,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Image.file(
                                      File(viewModel.photoPath),
                                      fit: BoxFit.cover,
                                    ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
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
                    color: Colors.black.withValues(alpha: 0.7),
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
                      child: SelectableText.rich(
                        _getTextSpan(
                          viewModel.errorMessage,
                          bodyLargeFontSize,
                        ),
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: bodyLargeFontSize,
                        ),
                      ),
                    ),
                  ),
              ],
            );

            return Column(
              children: <Widget>[
                if (kIsWeb)
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.8,
                    child: cameraStack,
                  )
                else
                  Expanded(child: cameraStack),
                if (!kIsWeb)
                  // Buttons for manual zoom control.
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: FloatingActionButton(
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

                                    // Take a picture and get the file path.
                                    final XFile? picture =
                                        await _controller?.takePicture();

                                    if (context.mounted && picture != null) {
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
                    ),
                  );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _adjustZoomLevel(double delta) {
    final double newZoomLevel = (_currentZoomLevel + delta).clamp(
      1.0,
      _maxZoomLevel,
    );
    if (!kIsWeb) {
      _controller?.setZoomLevel(newZoomLevel);
    }

    setState(() {
      _currentZoomLevel = newZoomLevel;
    });
  }

  TextSpan _getTextSpan(String text, double? fontSize) {
    if (text.isEmpty) {
      return const TextSpan();
    }

    final List<Match> emailMatches = _emailExp.allMatches(text).toList();
    final List<Match> urlMatches = _urlExp.allMatches(text).toList();

    // Combine and sort all matches by their start index
    final List<Match> allMatches = <Match>[...emailMatches, ...urlMatches];
    allMatches.sort((Match a, Match b) => a.start.compareTo(b.start));

    // Filter out overlapping matches, preferring longer ones or a specific
    // type if needed.
    // For simplicity here, we'll filter out matches fully contained within
    // another, preferring the container.
    final List<Match> filteredMatches = <Match>[];
    if (allMatches.isNotEmpty) {
      filteredMatches.add(allMatches.first);
      for (int i = 1; i < allMatches.length; i++) {
        final Match current = allMatches[i];
        final Match previous = filteredMatches.last;
        // If current match starts after previous one ends, add it.
        if (current.start >= previous.end) {
          filteredMatches.add(current);
        }
      }
    }

    if (filteredMatches.isEmpty) {
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
    int currentPosition = 0;

    for (final Match match in filteredMatches) {
      // Add text before the match.
      if (match.start > currentPosition) {
        spans.add(
          TextSpan(
            text: text.substring(currentPosition, match.start),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        );
      }

      final String matchedText = match.group(0)!;
      final bool isEmail = _emailExp.hasMatch(matchedText) &&
          emailMatches.any(
            (Match m) => m.start == match.start && m.end == match.end,
          );
      // Note: A simple URL regex might also match an email. Prioritize email
      // if it's a full email match.
      // If an email is also a URL (e.g. user@example.com), this logic treats
      // it as an email.

      if (isEmail) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: TextStyle(
              color: Colors.lightBlueAccent, // Email link color
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri emailLaunchUri = Uri(
                  scheme: kMailToScheme,
                  path: matchedText,
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  debugPrint('Could not launch $emailLaunchUri');
                  // Consider showing a Snackbar to the user
                  throw PlatformException(
                    // Keep throwing for internal handling if needed.
                    code: 'UNABLE_TO_LAUNCH_URL',
                    message: 'Could not launch $emailLaunchUri',
                  );
                }
              },
          ),
        );
      } else {
        // It's a URL (that wasn't primarily identified as an email).
        spans.add(
          TextSpan(
            text: matchedText,
            style: TextStyle(
              color: Colors.greenAccent,
              // URL link color (differentiate from email)
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                String urlToLaunch = matchedText;
                if (!urlToLaunch.startsWith('http://') &&
                    !urlToLaunch.startsWith('https://')) {
                  // Default to https.
                  urlToLaunch = 'https://$urlToLaunch';
                }
                final Uri urlLaunchUri = Uri.parse(urlToLaunch);
                if (await canLaunchUrl(urlLaunchUri)) {
                  await launchUrl(urlLaunchUri);
                } else {
                  debugPrint('Could not launch $urlLaunchUri');
                  _showUnableToLaunchUrlSnackbar(urlLaunchUri.toString());
                }
              },
          ),
        );
      }
      currentPosition = match.end;
    }

    // Add any remaining text after the last match.
    if (currentPosition < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentPosition),
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

  Future<void> _configureCamera() async {
    final CameraValue? camera = _controller?.value;
    if (!kIsWeb && camera?.isInitialized == true) {
      try {
        await _controller?.setFlashMode(FlashMode.off);
      } on CameraException catch (_) {
        // Intentionally left blank, since we do not want to turn on flash
        // anyway.
      }
      _controller?.getMaxZoomLevel().then((double max) {
        _maxZoomLevel = max;
      });
      _controller?.setFocusMode(FocusMode.auto);
    }
  }

  /// Helper function to show [SnackBar].
  void _showUnableToLaunchUrlSnackbar(String url) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${translate('could_not_launch')} $url'),
      ),
    );
  }
}
