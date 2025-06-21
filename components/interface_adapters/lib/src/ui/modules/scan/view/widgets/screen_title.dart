import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final Dimens dimens = resources.dimens;
    final EdgeInsets paddingTop = EdgeInsets.only(
      top: MediaQuery.paddingOf(context).top,
      left: dimens.leftPadding,
    );
    return Container(
      alignment: Alignment.topCenter,
      padding: paddingTop,
      child: Text(
        translate('title'),
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
        textScaler: const TextScaler.linear(1.4),
      ),
    );
  }
}
