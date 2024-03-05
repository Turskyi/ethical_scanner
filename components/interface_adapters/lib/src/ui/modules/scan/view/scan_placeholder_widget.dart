import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/scan_animation.dart';

class ScanPlaceholderWidget extends StatelessWidget {
  const ScanPlaceholderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define meaningful names for dimensions
    const double containerPadding = 12.0;
    const double borderRadiusValue = 8.0;
    const double verticalSpacing = 10.0;
    return Container(
      padding: const EdgeInsets.all(containerPadding),
      decoration: const BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadiusValue),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ScanAnimation(),
          const SizedBox(height: verticalSpacing),
          Text(
            translate('scan.scanning'),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(
                context,
              ).textTheme.titleLarge?.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
