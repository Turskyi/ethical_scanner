import 'dart:io';

import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/edit_product_details_dialog.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/evidence_photo_dialog.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/remove_ingredients_dialog.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/terrorism_documents_bottom_sheet.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/country_documents.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductInfoTile extends StatelessWidget {
  const ProductInfoTile({
    required this.type,
    required this.info,
    this.value = '',
    super.key,
  });

  final ProductInfoType type;
  final String value;
  final ProductInfo info;

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final MaterialColors colors = resources.colors;
    final Color color = value.isEmpty ? Colors.white : colors.cetaceanBlue;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isIngredientsMissing =
        type.isIngredients && value.isEmpty && info.imageIngredientsUrl.isEmpty;
    final bool isNotIngredients =
        type.isIngredients && value.isNotEmpty && _isCustomerServiceText;
    final bool isIngredientsImageAdded =
        type.isIngredients &&
        value.isEmpty &&
        info.imageIngredientsUrl.isNotEmpty;
    final bool isCameraGenerallySupported =
        kIsWeb || Platform.isAndroid || Platform.isIOS;
    final ProductResponseType responseType = info.responseType;

    // We do not want to show the camera button on web, because OpenFoodFacts
    // do not support CORS.
    // See https://github.com/openfoodfacts/openfoodfacts-dart/issues/1089
    final bool canSnapIngredients =
        (isIngredientsMissing || isNotIngredients) &&
        isCameraGenerallySupported &&
        !kIsWeb &&
        responseType.isSupportedByOpenFoodFacts;

    final bool canShowMarkAsNonFood =
        isIngredientsMissing &&
        (responseType.isBarcodeOnly || info.name.isEmpty);

    final bool isRedBackground =
        info.isCompanyTerrorismSponsor ||
        info.isFromRussia ||
        info.isFromBelarus;
    final bool isRed =
        info.isCompanyTerrorismSponsor ||
        info.isFromRussia ||
        info.isFromBelarus ||
        info.isGs1CountryStateSponsorOfTerrorism;
    final bool isGreenBackground = info.isVegan || info.isVegetarian;

    final bool isRedFlag =
        type == ProductInfoType.gs1Country &&
        info.isGs1CountryStateSponsorOfTerrorism &&
        !isRedBackground;

    final bool isGreenFlag =
        ((type == ProductInfoType.isVegan && info.isVegan) ||
            (type == ProductInfoType.isVegetarian && info.isVegetarian)) &&
        !isGreenBackground;

    if (isIngredientsMissing && !canSnapIngredients) {
      return const SizedBox.shrink();
    } else {
      final bool isIngredientsImageAddedOrNotIngredients =
          isIngredientsImageAdded || isNotIngredients;

      return ListTile(
        textColor: color,
        iconColor: color,
        leading: (type.isProductName || type.isIngredients) && value.isNotEmpty
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                  customBorder: const CircleBorder(),
                  onTap: () => type.isProductName
                      ? _onLongPressProductName(context)
                      : _onLongPressIngredients(context),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            : IconButton(
                icon: Icon(
                  _getIconData(
                    canSnapIngredients: canSnapIngredients,
                    isIngredientsImageAdded:
                        isIngredientsImageAddedOrNotIngredients,
                    isRedBackground: isRedBackground,
                    isGreenBackground: isGreenBackground,
                  ),
                  color: isRedFlag
                      ? Theme.of(context).colorScheme.error
                      : isGreenFlag
                      ? Colors.green
                      : null,
                ),
                onPressed: canSnapIngredients
                    ? () => context.read<HomePresenter>().add(
                        const SnapIngredientsEvent(),
                      )
                    : isIngredientsImageAddedOrNotIngredients
                    ? () => context.read<HomePresenter>().add(
                        const EditIngredientsEvent(),
                      )
                    : isRedFlag
                    ? () => _onStateSponsorsTerrorismTap(context, resources)
                    : null,
              ),
        title: SelectableText(
          translate(type.key),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: textTheme.titleLarge?.fontSize,
          ),
        ),
        subtitle: type.isCompanyWarSponsor
            ? RichText(
                text: TextSpan(
                  text: value,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: textTheme.bodyLarge?.fontSize,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: translate('product_info.leave_russia'),
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                        fontSize: textTheme.bodyLarge?.fontSize,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _onWarSponsorsSecondarySourceTap(resources);
                        },
                    ),
                    TextSpan(
                      text: ' · ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                    TextSpan(
                      text: translate('product_info.yale_list'),
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                        fontSize: textTheme.bodyLarge?.fontSize,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _onWarSponsorsPrimarySourceTap(resources);
                        },
                    ),
                  ],
                ),
              )
            : type.isWebsite
            ? Text(
                '$value ${translate('product_info.click_to_know')}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: textTheme.bodyLarge?.fontSize,
                  decoration: TextDecoration.underline,
                ),
              )
            : type.isTerrorismSponsor
            ? Text(
                '$value ${translate('terrorism_sponsor.tap_for_documents')}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: textTheme.bodyLarge?.fontSize,
                  decoration: TextDecoration.underline,
                ),
              )
            : type.isReportedOrigin && info.reportedOriginPhotos.isNotEmpty
            ? RichText(
                text: TextSpan(
                  text: value,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: textTheme.bodyLarge?.fontSize,
                    color: color,
                  ),
                  children: <TextSpan>[
                    for (
                      int i = 0;
                      i < info.reportedOriginPhotos.length;
                      i++
                    ) ...<TextSpan>[
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: info.reportedOriginPhotos.length == 1
                            ? translate('product_info.view_evidence_photo')
                            : '${translate('product_info.'
                              'view_evidence_photo')} #${i + 1}',
                        style: TextStyle(
                          color: color,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                          fontSize: textTheme.bodyLarge?.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _onViewEvidencePhotoTap(
                              context: context,
                              photoPath: info.reportedOriginPhotos[i],
                            );
                          },
                      ),
                    ],
                  ],
                ),
              )
            : type == ProductInfoType.countryAi
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    value,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                  if (info.infoAiModel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        translate(
                          'product_info.ai_model',
                          args: <String, Object?>{'model': info.infoAiModel},
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: color.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                ],
              )
            : type.isIngredients &&
                  value.isNotEmpty &&
                  !isRed &&
                  !_isCustomerServiceText &&
                  info.vegetarian == Vegetarian.unknown
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectionArea(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _onCheckVegetarianWithAi(context, value),
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: Text(translate('product_info.check_vegetarian_ai')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            : isIngredientsMissing && canShowMarkAsNonFood
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectionArea(
                    child: Text(
                      translate('product_info.ingredients_missing'),
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  OutlinedButton.icon(
                    onPressed: () => _onMarkAsNonFood(context),
                    icon: const Icon(Icons.devices_other, size: 18),
                    label: Text(translate('product_info.mark_as_non_food')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            : SelectionArea(
                child: Text(
                  value +
                      (isIngredientsMissing
                          ? translate('product_info.ingredients_missing')
                          : isIngredientsImageAdded
                          ? translate('product_info.ingredients_image_added')
                          : ''),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: textTheme.bodyLarge?.fontSize,
                  ),
                ),
              ),
        onTap: type.isWebsite || type.isTerrorismSponsor
            ? () {
                if (type.isTerrorismSponsor) {
                  _onTerrorismSponsorTap(context);
                } else {
                  _onLinkTap(context, resources);
                }
              }
            : null,
        onLongPress:
            (type.isProductName || type.isIngredients) && value.isNotEmpty
            ? () => type.isProductName
                  ? _onLongPressProductName(context)
                  : _onLongPressIngredients(context)
            : null,
      );
    }
  }

  Future<void> _onLongPressProductName(BuildContext context) {
    return EditProductDetailsDialog.show(
      context: context,
      barcode: info.barcode,
      currentName: value,
      canHaveIngredients: info.hasIngredients,
    );
  }

  Future<void> _onLongPressIngredients(BuildContext context) {
    return RemoveIngredientsDialog.show(
      context: context,
      barcode: info.barcode,
    );
  }

  /// Launches the primary source URL for war sponsors.
  ///
  /// Returns `true` if the URL was successfully launched, `false` otherwise.
  Future<bool> _onWarSponsorsPrimarySourceTap(Resources resources) {
    final Uri link = Uri.parse(resources.strings.russiaSponsorsSource1);
    return launchUrl(link);
  }

  /// Launches the secondary source URL for war sponsors.
  ///
  /// Returns `true` if the URL was successfully launched, `false` otherwise.
  Future<bool> _onWarSponsorsSecondarySourceTap(Resources resources) {
    final String url = info.leaveRussiaUrl.isNotEmpty
        ? info.leaveRussiaUrl
        : resources.strings.russiaSponsorsSource2;
    final Uri link = Uri.parse(url);
    return launchUrl(link);
  }

  void _onStateSponsorsTerrorismTap(BuildContext context, Resources resources) {
    return context.read<HomePresenter>().add(
      LaunchUrlEvent(
        uri: resources.strings.stateSponsorsTerrorismSource,
        language: Language.fromIsoLanguageCode(
          LocalizedApp.of(context).delegate.currentLocale.languageCode,
        ),
      ),
    );
  }

  void _onTerrorismSponsorTap(BuildContext context) {
    final CountryDocuments countryDocs = CountryDocuments.forProductInfo(info);
    if (countryDocs.isEmpty) {
      final Resources resources = Resources.of(context);
      _onLinkTap(context, resources);
    } else {
      TerrorismDocumentsBottomSheet.show(context, documents: countryDocs);
    }
  }

  void _onLinkTap(BuildContext context, Resources resources) {
    return context.read<HomePresenter>().add(
      LaunchUrlEvent(
        uri: type.isTerrorismSponsor
            ? resources.strings.russiaTerrorismSponsorSource
            : value,
        language: Language.fromIsoLanguageCode(
          LocalizedApp.of(context).delegate.currentLocale.languageCode,
        ),
      ),
    );
  }

  void _onCheckVegetarianWithAi(BuildContext context, String ingredientsText) {
    return context.read<HomePresenter>().add(
      CheckVegetarianWithAiEvent(
        ingredients: ingredientsText,
        barcode: info.barcode,
      ),
    );
  }

  void _onMarkAsNonFood(BuildContext context) {
    return context.read<HomePresenter>().add(
      MarkAsNonFoodProductEvent(barcode: info.barcode),
    );
  }

  Future<void> _onViewEvidencePhotoTap({
    required BuildContext context,
    required String photoPath,
  }) {
    return EvidencePhotoDialog.show(context: context, photoUrl: photoPath);
  }

  bool get _isCustomerServiceText {
    final String lowerValue = value.toLowerCase();
    return lowerValue.contains('call') ||
        lowerValue.contains('questions') ||
        lowerValue.contains('comments') ||
        lowerValue.contains('contact') ||
        lowerValue.contains('consumer') ||
        lowerValue.contains('service') ||
        lowerValue.contains('1-800') ||
        lowerValue.contains('1-888') ||
        lowerValue.contains('1-877') ||
        lowerValue.contains('1-866') ||
        lowerValue.contains('1-855') ||
        lowerValue.contains('1-844') ||
        lowerValue.contains('1-833') ||
        lowerValue.contains('http') ||
        lowerValue.contains('www.');
  }

  IconData _getIconData({
    required bool canSnapIngredients,
    required bool isIngredientsImageAdded,
    required bool isRedBackground,
    required bool isGreenBackground,
  }) {
    return () {
      if (type.isCompanyWarSponsor) {
        return Icons.priority_high;
      } else if (type == ProductInfoType.gs1Country &&
          info.isGs1CountryStateSponsorOfTerrorism &&
          !isRedBackground) {
        return Icons.flag;
      } else if (type == ProductInfoType.isVegan &&
          info.isVegan &&
          !isGreenBackground) {
        return Icons.flag;
      } else if (type == ProductInfoType.isVegetarian &&
          info.isVegetarian &&
          !isGreenBackground) {
        return Icons.flag;
      } else if (canSnapIngredients) {
        return Icons.camera_alt_outlined;
      } else if (isIngredientsImageAdded) {
        return Icons.edit_outlined;
      } else {
        return Icons.star;
      }
      // Call the function immediately `()` and use the returned value as
      // the `icon` parameter.
    }();
  }
}
