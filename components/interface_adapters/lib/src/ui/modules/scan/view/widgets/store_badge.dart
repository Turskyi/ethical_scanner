import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreBadge extends StatelessWidget {
  const StoreBadge({
    required this.url,
    required this.assetPath,
    this.height = 100,
    this.width = 240,
    this.borderRadius = 8.0,
    super.key,
  });

  final String url;
  final String assetPath;
  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${translate('scan.could_not_launch')} $url'),
                ),
              );
            }
          },
          child: Ink(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              image: DecorationImage(
                image: AssetImage(assetPath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
