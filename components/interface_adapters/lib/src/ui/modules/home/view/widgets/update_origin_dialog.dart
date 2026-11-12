import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/evidence_photo_dialog.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class UpdateOriginDialog extends StatefulWidget {
  const UpdateOriginDialog({
    required this.barcode,
    required this.initialCountry,
    required this.existingPhotos,
    super.key,
  });

  final String barcode;
  final String initialCountry;
  final List<String> existingPhotos;

  static Future<void> show({
    required BuildContext context,
    required String barcode,
    required String initialCountry,
    required List<String> existingPhotos,
  }) {
    final HomePresenter homePresenter = context.read<HomePresenter>();
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext routeContext) {
          return BlocProvider<HomePresenter>.value(
            value: homePresenter,
            child: UpdateOriginDialog(
              barcode: barcode,
              initialCountry: initialCountry,
              existingPhotos: existingPhotos,
            ),
          );
        },
      ),
    );
  }

  @override
  State<UpdateOriginDialog> createState() => _UpdateOriginDialogState();
}

class _UpdateOriginDialogState extends State<UpdateOriginDialog> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedPhotoPath;
  OpenFoodFactsCountry? _selectedCountry;

  @override
  void initState() {
    super.initState();
    for (final OpenFoodFactsCountry country in OpenFoodFactsCountry.values) {
      if (_formatCountryName(country).toLowerCase() ==
          widget.initialCountry.toLowerCase()) {
        _selectedCountry = country;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Gradients gradients = Resources.of(context).gradients;

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
            translate('product_info.update_origin_title'),
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
                    translate('product_info.update_origin_description'),
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  if (widget.existingPhotos.isNotEmpty) ...<Widget>[
                    Text(
                      translate('product_info.existing_photos'),
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.existingPhotos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String photoUrl = widget.existingPhotos[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                EvidencePhotoDialog.show(
                                  context: context,
                                  photoUrl: photoUrl,
                                  barcode: widget.barcode,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  photoUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildPhotoSection(context),
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
                    initialValue: TextEditingValue(
                      text: _selectedCountry != null
                          ? _formatCountryName(_selectedCountry!)
                          : widget.initialCountry,
                    ),
                    displayStringForOption: (OpenFoodFactsCountry country) =>
                        _formatCountryName(country),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return OpenFoodFactsCountry.values;
                      } else {
                        return OpenFoodFactsCountry.values.where((
                          OpenFoodFactsCountry country,
                        ) {
                          return _formatCountryName(country)
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
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
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
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
                              hintStyle: const TextStyle(color: Colors.white38),
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
                      onPressed: _selectedCountry != null
                          ? _onSavePressed
                          : null,
                      child: Text(translate('save')),
                    ),
                  ),
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

  Widget _buildPhotoSection(BuildContext context) {
    if (_selectedPhotoPath != null && _selectedPhotoPath!.isNotEmpty) {
      return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(_selectedPhotoPath!),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedPhotoPath = null;
              });
            },
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.photo_camera),
              label: Text(translate('product_info.take_photo')),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.photo_library),
              label: Text(translate('product_info.choose_gallery')),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ),
        ],
      );
    }
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
      });
    }
  }

  String _formatCountryName(OpenFoodFactsCountry country) {
    final String name = country.name.replaceAll('_', ' ').toLowerCase();
    return name
        .split(' ')
        .map((String word) {
          if (word.isEmpty) {
            return '';
          } else {
            return word[0].toUpperCase() + word.substring(1);
          }
        })
        .join(' ');
  }

  void _onSavePressed() {
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('product_info.enter_country_warning')),
        ),
      );
    } else {
      final String countryName = _formatCountryName(_selectedCountry!);
      Navigator.of(context).pop();
      context.read<HomePresenter>().add(
        AddOriginEvent(
          barcode: widget.barcode,
          origin: countryName,
          photoPath: _selectedPhotoPath ?? '',
        ),
      );
    }
  }
}
