import 'dart:io';

import 'package:camera/camera.dart';
import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_event.dart';
import 'package:interface_adapters/src/ui/modules/photo/photo_presenter.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.cameraDescriptions.isNotEmpty) {
      _controller = CameraController(
        widget.cameraDescriptions.first,
        ResolutionPreset.medium,
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
    Dimens dimens = Resources.of(context).dimens;
    return Scaffold(
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

          // calculate scale depending on screen and camera ratios
          // this is actually size.aspectRatio / (1 / camera.aspectRatio)
          // because camera preview size is received as landscape
          // but we're calculating for portrait orientation
          double scale = size.aspectRatio *
              (camera.isInitialized ? camera.aspectRatio : 1.0);

          // to prevent scaling down, invert the value
          if (scale < 1) scale = 1 / scale;

          if (camera.isInitialized) {
            _controller.setFlashMode(FlashMode.off);
          }

          return Stack(
            children: <Widget>[
              Transform.scale(
                scale: scale,
                child: Center(
                  child: CameraPreview(_controller),
                ),
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
                            // Remove the preview and reset the captured image
                            // path.
                            context
                                .read<PhotoPresenter>()
                                .add(const RemovePhotoEvent());
                          },
                          child: Container(
                            width: 200.0, // Increased width
                            height: 350, // Increased height
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
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
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              if (viewModel is AddIngredientsErrorState)
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    viewModel.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<PhotoPresenter, PhotoViewModel>(
        builder: (BuildContext context, PhotoViewModel viewModel) {
          return FloatingActionButton(
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
                          XFile picture = await _controller.takePicture();

                          if (mounted) {
                            context
                                .read<PhotoPresenter>()
                                .add(TakenPhotoEvent(picture.path));
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
