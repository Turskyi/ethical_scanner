import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/country_localizer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Gradients gradients = Resources.of(context).gradients;

    final bool showCountryAndSave =
        _selectedPhotoPath != null && _selectedPhotoPath!.isNotEmpty;

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
                  _buildPhotoSection(context),
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
                      displayStringForOption: (OpenFoodFactsCountry country) =>
                          _formatCountryName(country),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return OpenFoodFactsCountry.values;
                        } else {
                          final String localeCode = Localizations.localeOf(
                            context,
                          ).languageCode;
                          return OpenFoodFactsCountry.values.where((
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
                        onPressed: _selectedCountry != null
                            ? _onSavePressed
                            : null,
                        child: Text(translate('save')),
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
                _selectedCountry = null;
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
    final String localeCode = Localizations.localeOf(context).languageCode;
    return CountryLocalizer.getLocalizedName(country, localeCode: localeCode);
  }

  void _onSavePressed() {
    final OpenFoodFactsCountry? country = _selectedCountry;
    if (country == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('product_info.enter_country_warning')),
        ),
      );
    } else {
      final String countryName = _formatCountryName(country);
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
