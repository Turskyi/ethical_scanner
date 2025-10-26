import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PrivacySection extends StatelessWidget {
  const PrivacySection({
    required this.contentKey,
    this.titleKey,
    super.key,
  });

  final String? titleKey;
  final String contentKey;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? title = titleKey == null ? null : translate(titleKey!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            translate(contentKey),
            style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
