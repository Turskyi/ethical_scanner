import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_event.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

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
            // Call the function immediately and use the returned value as the
            // icon parameter.
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
      subtitle: Text(
        value +
            (type.isWebsite ||
                    type.isCompanyWarSponsor ||
                    type.isTerrorismSponsor
                ? translate('product_info.click_to_know')
                : isIngredientsMissing
                    ? translate('product_info.ingredients_missing')
                    : isIngredientsImageAdded
                        ? translate('product_info.ingredients_image_added')
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
      onTap:
          type.isWebsite || type.isCompanyWarSponsor || type.isTerrorismSponsor
              ? () => context.read<HomePresenter>().add(
                    LaunchUrlEvent(
                      uri: type.isCompanyWarSponsor
                          ? resources.strings.warSponsorSource
                          : type.isTerrorismSponsor
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
