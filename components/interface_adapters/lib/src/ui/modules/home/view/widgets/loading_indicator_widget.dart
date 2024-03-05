import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Resources resources = Resources.of(context);
    MaterialColors colors = resources.colors;
    Dimens dimens = resources.dimens;
    return Padding(
      padding: EdgeInsets.all(dimens.circularProgressPadding),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colors.cetaceanBlue),
          strokeWidth: dimens.circularProgressStrokeWidth,
          backgroundColor: colors.antiFlashWhite,
        ),
      ),
    );
  }
}
