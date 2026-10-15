import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class EvidencePhotoDialog extends StatelessWidget {
  const EvidencePhotoDialog({required this.photoUrl, super.key});

  final String photoUrl;

  static const double _maxDialogWidth = 600.0;
  static const double _maxDialogHeight = 600.0;
  static const double _dialogBorderRadius = 28.0;
  static const double _imageBorderRadius = 16.0;
  static const double _dialogPadding = 16.0;
  static const double _spacingHeight = 12.0;
  static const double _errorIconSize = 48.0;
  static const double _reportIconSize = 18.0;

  static Future<void> show({
    required BuildContext context,
    required String photoUrl,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return EvidencePhotoDialog(photoUrl: photoUrl);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LinearGradient backgroundGradient = Resources.of(
      context,
    ).gradients.pinkSunriseGradientBackground;

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogBorderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(_dialogBorderRadius),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: _maxDialogWidth,
            maxHeight: _maxDialogHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(_dialogPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_imageBorderRadius),
                    child: InteractiveViewer(
                      child: Image.network(
                        photoUrl,
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? progress,
                            ) {
                              if (progress == null) {
                                return child;
                              } else {
                                final int? total = progress.expectedTotalBytes;
                                final int loaded =
                                    progress.cumulativeBytesLoaded;
                                final double? value = total != null && total > 0
                                    ? loaded / total
                                    : null;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: value,
                                  ),
                                );
                              }
                            },
                        errorBuilder:
                            (BuildContext _, Object _, StackTrace? _) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(_dialogPadding),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.broken_image_outlined,
                                        size: _errorIconSize,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(height: _spacingHeight),
                                      Text(
                                        translate('photo.failed_to_load_image'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: _spacingHeight),
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.bug_report_outlined,
                                          size: _reportIconSize,
                                        ),
                                        label: Text(
                                          translate('photo.report_problem'),
                                        ),
                                        onPressed: _onReportProblemTap,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _spacingHeight),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(translate('close')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onReportProblemTap() {
    final String subject = Uri.encodeComponent('Failed to load evidence photo');
    final String body = Uri.encodeComponent(
      'The evidence photo failed to load in Ethical Scanner.\n\n'
      'Image URL: $photoUrl',
    );
    final Uri mailUri = Uri.parse(
      '$kMailToScheme:$kSupportEmail?$kSubjectParameter=$subject&'
      '$kBodyParameter=$body',
    );
    return launchUrl(mailUri, mode: LaunchMode.externalApplication);
  }
}
