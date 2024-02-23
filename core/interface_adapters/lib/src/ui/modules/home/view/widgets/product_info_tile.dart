import 'package:entities/entities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductInfoTile extends StatelessWidget {
  const ProductInfoTile({
    super.key,
    required this.type,
    required this.info,
    this.value = '',
  });

  final ProductInfoType type;
  final String value;
  final ProductInfo info;

  @override
  Widget build(BuildContext context) {
    Resources resources = Resources.of(context);
    MaterialColors colors = resources.colors;
    Color color = value.isEmpty ? Colors.white : colors.cetaceanBlue;
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isIngredientsMissing =
        type.isIngredients && value.isEmpty && info.imageIngredientsUrl.isEmpty;
    bool isIngredientsImageAdded = type.isIngredients &&
        value.isEmpty &&
        info.imageIngredientsUrl.isNotEmpty;
    return ListTile(
      textColor: color,
      iconColor: color,
      leading: IconButton(
        icon: Icon(
          () {
            if (type.isCompanyWarSponsor) {
              return Icons.question_mark;
            } else if (isIngredientsMissing) {
              return Icons.camera_alt_outlined;
            } else if (isIngredientsImageAdded) {
              return Icons.construction;
            } else {
              return Icons.star;
            }
            // Call the function immediately `()` and use the returned value as
            // the `icon` parameter.
          }(),
        ),
        onPressed: isIngredientsMissing
            ? () => context.read<HomePresenter>().add(
                  const SnapIngredientsEvent(),
                )
            : null,
      ),
      title: Text(
        translate(type.key),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: textTheme.titleLarge?.fontSize,
        ),
      ),
      subtitle: type.isCompanyWarSponsor
          ? RichText(
              text: TextSpan(
                text: value + translate('product_info.click'),
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
                          resources.strings.warSponsorsSource,
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
                          resources.strings.russiaSponsorsSource,
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
          : Text(
              value +
                  (type.isWebsite || type.isTerrorismSponsor
                      ? translate('product_info.click_to_know')
                      : isIngredientsMissing
                          ? translate('product_info.ingredients_missing')
                          : isIngredientsImageAdded
                              ? translate(
                                  'product_info.ingredients_image_added',
                                )
                              : ''),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: textTheme.bodyLarge?.fontSize,
                decoration: type.isWebsite ||
                        type.isCompanyWarSponsor ||
                        type.isTerrorismSponsor
                    ? TextDecoration.underline
                    : null,
              ),
            ),
      onTap: type.isWebsite || type.isTerrorismSponsor
          ? () => context.read<HomePresenter>().add(
                LaunchUrlEvent(
                  uri: type.isTerrorismSponsor
                      ? resources.strings.russiaTerrorismSponsorSource
                      : value,
                  language: Language.fromIsoLanguageCode(
                    LocalizedApp.of(context)
                        .delegate
                        .currentLocale
                        .languageCode,
                  ),
                ),
              )
          : null,
    );
  }
}
