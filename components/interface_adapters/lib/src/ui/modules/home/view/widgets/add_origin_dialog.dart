import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/origin_photo_picker_section.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/country_localizer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:path_provider/path_provider.dart';

class AddOriginDialog extends StatefulWidget {
  const AddOriginDialog({required this.barcode, super.key});

  final String barcode;

  static Future<void> show({
    required BuildContext context,
    required String barcode,
  }) {
    final HomePresenter homePresenter = context.read<HomePresenter>();
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext routeContext) {
          return BlocProvider<HomePresenter>.value(
            value: homePresenter,
            child: AddOriginDialog(barcode: barcode),
          );
        },
      ),
    );
  }

  @override
  State<AddOriginDialog> createState() => _AddOriginDialogState();
}

class _AddOriginDialogState extends State<AddOriginDialog> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedPhotoPath;
  OpenFoodFactsCountry? _selectedCountry;
  int _rotationTurns = 0;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Gradients gradients = Resources.of(context).gradients;

    final String? selectedPhotoPath = _selectedPhotoPath;
    final bool showCountryAndSave =
        selectedPhotoPath != null && selectedPhotoPath.isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradients.pinkSunriseGradientBackground,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: Navigator.of(context).pop,
          ),
          title: Text(
            translate('product_info.add_origin_title'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    translate('product_info.add_origin_description'),
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  OriginPhotoPickerSection(
                    photoPath: _selectedPhotoPath,
                    rotationTurns: _rotationTurns,
                    onPickImage: _pickImage,
                    onRotatePhoto: () {
                      setState(() {
                        _rotationTurns = (_rotationTurns + 1) % 4;
                      });
                    },
                    onRemovePhoto: () {
                      setState(() {
                        _selectedPhotoPath = null;
                        _selectedCountry = null;
                        _rotationTurns = 0;
                      });
                    },
                  ),
                  if (showCountryAndSave) ...<Widget>[
                    const SizedBox(height: 24),
                    Text(
                      translate('product_info.origin_country_label'),
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Autocomplete<OpenFoodFactsCountry>(
                      displayStringForOption: _formatCountryName,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final String localeCode = LocalizedApp.of(
                          context,
                        ).delegate.currentLocale.languageCode;
                        final List<OpenFoodFactsCountry> countries =
                            List<OpenFoodFactsCountry>.from(
                              OpenFoodFactsCountry.values,
                            );
                        countries.sort((
                          OpenFoodFactsCountry a,
                          OpenFoodFactsCountry b,
                        ) {
                          final String nameA =
                              CountryLocalizer.getLocalizedName(
                                a,
                                localeCode: localeCode,
                              );
                          final String nameB =
                              CountryLocalizer.getLocalizedName(
                                b,
                                localeCode: localeCode,
                              );
                          return nameA.compareTo(nameB);
                        });
                        if (textEditingValue.text.isEmpty) {
                          return countries;
                        } else {
                          return countries.where((
                            OpenFoodFactsCountry country,
                          ) {
                            return CountryLocalizer.matches(
                              country,
                              textEditingValue.text,
                              localeCode: localeCode,
                            );
                          });
                        }
                      },
                      onSelected: (OpenFoodFactsCountry selection) {
                        setState(() {
                          _selectedCountry = selection;
                        });
                      },
                      fieldViewBuilder:
                          (
                            BuildContext _,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback _,
                          ) {
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: translate(
                                  'product_info.origin_country_label',
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                hintText: translate(
                                  'product_info.origin_country_hint',
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.white38,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white38),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _selectedCountry != null && !_isSaving
                            ? _onSavePressed
                            : null,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(translate('save')),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedPhotoPath = image.path;
        _rotationTurns = 0;
      });
    }
  }

  String _formatCountryName(OpenFoodFactsCountry country) {
    final String localeCode = LocalizedApp.of(
      context,
    ).delegate.currentLocale.languageCode;
    return CountryLocalizer.getLocalizedName(country, localeCode: localeCode);
  }

  Future<void> _onSavePressed() async {
    final OpenFoodFactsCountry? country = _selectedCountry;
    final String? photoPath = _selectedPhotoPath;
    if (country == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('product_info.enter_country_warning')),
        ),
      );
    } else if (_isSaving) {
      return;
    } else {
      setState(() {
        _isSaving = true;
      });
      final String? rotatedPhotoPath = photoPath == null || photoPath.isEmpty
          ? photoPath
          : await _rotatePhotoFile(photoPath);
      if (mounted) {
        if (photoPath != null && rotatedPhotoPath == null) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(translate('photo.failed_to_load_image'))),
          );
        } else {
          final String countryName = _formatCountryName(country);
          final HomePresenter presenter = context.read<HomePresenter>();
          Navigator.of(context).pop();
          presenter.add(
            AddOriginEvent(
              barcode: widget.barcode,
              origin: countryName,
              photoPath: rotatedPhotoPath ?? '',
            ),
          );
        }
      }
    }
  }

  Future<String?> _rotatePhotoFile(String originalPath) async {
    if (_rotationTurns == 0) {
      return originalPath;
    } else {
      try {
        final Uint8List bytes = await File(originalPath).readAsBytes();
        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final ui.Image image = frameInfo.image;
        final bool isQuarterTurn = _rotationTurns.isOdd;
        final int outputWidth = isQuarterTurn ? image.height : image.width;
        final int outputHeight = isQuarterTurn ? image.width : image.height;
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final ui.Canvas canvas = ui.Canvas(recorder);

        if (_rotationTurns == 1) {
          canvas.translate(outputWidth.toDouble(), 0);
          canvas.rotate(math.pi / 2);
        } else if (_rotationTurns == 2) {
          canvas.translate(outputWidth.toDouble(), outputHeight.toDouble());
          canvas.rotate(math.pi);
        } else {
          canvas.translate(0, outputHeight.toDouble());
          canvas.rotate(3 * math.pi / 2);
        }

        canvas.drawImage(image, ui.Offset.zero, ui.Paint());
        final ui.Picture picture = recorder.endRecording();
        final ui.Image rotatedImage = await picture.toImage(
          outputWidth,
          outputHeight,
        );
        final ByteData? byteData = await rotatedImage.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData == null) {
          return null;
        } else {
          final Directory tempDirectory = await getTemporaryDirectory();
          final String rotatedPath =
              '${tempDirectory.path}/rotated_'
              '${DateTime.now().millisecondsSinceEpoch}.png';
          await File(rotatedPath).writeAsBytes(byteData.buffer.asUint8List());
          return rotatedPath;
        }
      } catch (e) {
        debugPrint('Failed to rotate photo: $e');
        return null;
      }
    }
  }
}
