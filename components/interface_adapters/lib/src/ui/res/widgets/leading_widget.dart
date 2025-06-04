import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeadingWidget extends StatelessWidget {
  const LeadingWidget({required this.logoPath, required this.onTap, super.key});

  /// Called when the user taps this part of the material.
  final GestureTapCallback onTap;
  final String logoPath;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final double leadingButtonSize = 60.0;
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: leadingButtonSize,
        height: leadingButtonSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            // Ensures the background remains unchanged.
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Ink.image(
                image: AssetImage(logoPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: onTap,
      );
    }
  }
}
