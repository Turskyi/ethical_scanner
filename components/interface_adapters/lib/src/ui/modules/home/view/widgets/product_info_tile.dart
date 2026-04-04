import 'dart:io';

import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
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
        isIngredientsMissing &&
        isCameraGenerallySupported &&
        !kIsWeb &&
        responseType.isSupportedByOpenFoodFacts;

    if (isIngredientsMissing && !canSnapIngredients) {
      return const SizedBox.shrink();
    }

    return ListTile(
      textColor: color,
      iconColor: color,
      leading: IconButton(
        icon: Icon(
          _getIconData(
            canSnapIngredients: canSnapIngredients,
            isIngredientsImageAdded: isIngredientsImageAdded,
          ),
        ),
        onPressed: canSnapIngredients
            ? () => context.read<HomePresenter>().add(
                const SnapIngredientsEvent(),
              )
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
                text: '$value ${translate('product_info.click')}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: textTheme.bodyLarge?.fontSize,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: translate('product_info.here'),
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                      fontSize: textTheme.bodyLarge?.fontSize,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final Uri link = Uri.parse(
                          resources.strings.russiaSponsorsSource1,
                        );
                        launchUrl(link);
                      },
                  ),
                  TextSpan(
                    text: translate('product_info.or'),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                  TextSpan(
                    text: translate('product_info.here'),
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                      fontSize: textTheme.bodyLarge?.fontSize,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final Uri link = Uri.parse(
                          resources.strings.russiaSponsorsSource2,
                        );
                        launchUrl(link);
                      },
                  ),
                  TextSpan(
                    text: translate('product_info.to_know_more'),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: textTheme.bodyLarge?.fontSize,
                    ),
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
    context.read<HomePresenter>().add(
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

  IconData _getIconData({
    required bool canSnapIngredients,
    required bool isIngredientsImageAdded,
  }) {
    return () {
      if (type.isCompanyWarSponsor) {
        return Icons.question_mark;
      } else if (canSnapIngredients) {
        return Icons.camera_alt_outlined;
      } else if (isIngredientsImageAdded) {
        return Icons.construction;
      } else {
        return Icons.star;
      }
      // Call the function immediately `()` and use the returned value as
      // the `icon` parameter.
    }();
  }
}
