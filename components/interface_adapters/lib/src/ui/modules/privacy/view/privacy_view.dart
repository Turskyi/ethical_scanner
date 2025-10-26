import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/privacy/view/widgets/privacy_section.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:interface_adapters/src/ui/widgets/home_app_bar_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyView extends StatefulWidget {
  const PrivacyView({
    required this.initialLanguage,
    super.key,
  });

  final Language initialLanguage;

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  @override
  void initState() {
    super.initState();
    final Language currentLanguage = Language.fromIsoLanguageCode(
      LocalizedApp.of(context).delegate.currentLocale.languageCode,
    );
    final Language savedLanguage = widget.initialLanguage;
    if (currentLanguage != savedLanguage) {
      changeLocale(context, savedLanguage.isoLanguageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Resources resources = Resources.of(context);
    final Locale locale = LocalizedApp.of(context).delegate.currentLocale;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: kIsWeb
            ? HomeAppBarButton(
                language: widget.initialLanguage,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: resources.gradients.unauthorizedConstructionGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Text(
                            translate('privacy_policy.main_title'),
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            translate('privacy_policy.subtitle'),
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[200]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrivacySection(
                      key: ValueKey<String>('${locale.languageCode}_intro'),
                      contentKey: 'privacy_policy.introduction',
                    ),
                    PrivacySection(
                      key: ValueKey<String>('${locale.languageCode}_collect'),
                      titleKey: 'privacy_policy.information_we_collect.title',
                      contentKey:
                          'privacy_policy.information_we_collect.content',
                    ),
                    PrivacySection(
                      key: ValueKey<String>(
                        '${locale.languageCode}_permissions',
                      ),
                      titleKey: 'privacy_policy.permissions.title',
                      contentKey: 'privacy_policy.permissions.content',
                    ),
                    PrivacySection(
                      key: ValueKey<String>('${locale.languageCode}_sharing'),
                      titleKey: 'privacy_policy.information_sharing.title',
                      contentKey: 'privacy_policy.information_sharing.content',
                    ),
                    PrivacySection(
                      key: ValueKey<String>('${locale.languageCode}_security'),
                      titleKey: 'privacy_policy.security.title',
                      contentKey: 'privacy_policy.security.content',
                    ),
                    PrivacySection(
                      key: ValueKey<String>('${locale.languageCode}_changes'),
                      titleKey: 'privacy_policy.changes.title',
                      contentKey: 'privacy_policy.changes.content',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              translate('privacy_policy.contact.title'),
                              style: textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SelectableText.rich(
                            TextSpan(
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: translate(
                                    'privacy_policy.contact.content_part1',
                                  ),
                                ),
                                TextSpan(
                                  text: ' $kSupportEmail',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: kMailToScheme,
                                        path: kSupportEmail,
                                      );
                                      await launchUrl(emailLaunchUri);
                                    },
                                ),
                                TextSpan(
                                  text: translate(
                                    'privacy_policy.contact.content_part2',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
