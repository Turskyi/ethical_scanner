import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:interface_adapters/src/ui/widgets/home_app_bar_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends StatefulWidget {
  const SupportView({
    required this.initialLanguage,
    super.key,
  });

  final Language initialLanguage;

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
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
    final Color linkColor = Colors.blue[200]!;
    final TextStyle? bodyTextStyle = textTheme.titleMedium?.copyWith(
      color: Colors.white,
    );
    final TextStyle linkStyle = bodyTextStyle!.copyWith(
      color: linkColor,
    );

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000C40), Color(0xFFF0F2F0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        translate('support.title'),
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        translate('support.intro'),
                        textAlign: TextAlign.center,
                        style: bodyTextStyle,
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: bodyTextStyle,
                          children: [
                            TextSpan(text: translate('support.email_prefix')),
                            TextSpan(
                              text: kSupportEmail,
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => _launchUrl('mailto:$kSupportEmail'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: bodyTextStyle,
                          children: [
                            TextSpan(
                                text: translate('support.telegram_prefix')),
                            TextSpan(
                              text: translate('support.telegram_link_text'),
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchUrl(
                                    'https://t.me/+B5gN1BLsVPo3M2My'),
                            ),
                            TextSpan(
                                text: translate('support.telegram_suffix')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: bodyTextStyle,
                          children: [
                            TextSpan(text: translate('support.website_prefix')),
                            TextSpan(
                              text: translate('support.website_link_text'),
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    _launchUrl('https://turskyi.com/#/support'),
                            ),
                            TextSpan(text: translate('support.website_suffix')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translate('support.future_plans'),
                        textAlign: TextAlign.center,
                        style:
                            textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          translate('support.back_to_home'),
                          style: TextStyle(
                            color: Colors.blue.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
