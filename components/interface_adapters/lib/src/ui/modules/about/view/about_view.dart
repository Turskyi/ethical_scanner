import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/router/routes.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/widgets/store_badge.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart';
import 'package:interface_adapters/src/ui/widgets/home_app_bar_button.dart';
import 'package:interface_adapters/src/ui/widgets/language_selector.dart';

class AboutView extends StatefulWidget {
  const AboutView({required this.initialLanguage, super.key});

  final Language initialLanguage;

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
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
    final String appName = translate('title');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: kIsWeb
            ? HomeAppBarButton(language: widget.initialLanguage)
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LanguageSelector(
              currentLanguage: Language.fromIsoLanguageCode(
                LocalizedApp.of(context).delegate.currentLocale.languageCode,
              ),
              onLanguageSelected: (Language newLanguage) {
                setState(() {});
              },
            ),
          ),
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 12),
                    Text(
                      translate('about.title'),
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      translate('about.subtitle'),
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      translate('about.scan_prompt'),
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translate('about.know_products'),
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        translate(
                          'about.description',
                          args: <String, Object?>{'appName': appName},
                        ),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white.withValues(alpha: 0.3),
                            highlightColor: Colors.white.withValues(alpha: 0.1),
                            onTap: () {
                              Navigator.pushNamed(context, kScanPath);
                            },
                            child: Ink.image(
                              image: const AssetImage(
                                '$kImagesPath'
                                'ethical_scanner_logo.jpeg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      translate('about.features_title'),
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildFeatureItem(
                            text: translate('about.feature_1'),
                            textTheme: textTheme,
                          ),
                          _buildFeatureItem(
                            text: translate('about.feature_2'),
                            textTheme: textTheme,
                          ),
                          _buildFeatureItem(
                            text: translate('about.feature_3'),
                            textTheme: textTheme,
                          ),
                          _buildFeatureItem(
                            text: translate('about.feature_4'),
                            textTheme: textTheme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      translate('about.screenshots_title'),
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 450,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          _buildScreenshot(
                            '$kImagesPath'
                            'screen1.jpeg',
                          ),
                          _buildScreenshot(
                            '$kImagesPath'
                            'screen2.jpeg',
                          ),
                          _buildScreenshot(
                            '$kImagesPath'
                            'screen3.jpeg',
                          ),
                          _buildScreenshot(
                            '$kImagesPath'
                            'screen4.jpeg',
                          ),
                          _buildScreenshot(
                            '$kImagesPath'
                            'screen5.jpeg',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      translate('about.download_title'),
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.blue.shade200,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translate('about.download_subtitle'),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: <Widget>[
                        StoreBadge(
                          url: kGooglePlayUrl,
                          assetPath:
                              '$kImagesPath'
                              'play_store_badge.png',
                          height: 58,
                          width: 150,
                        ),
                        StoreBadge(
                          url: kAppStoreUrl,
                          assetPath:
                              '$kImagesPath'
                              'Download_on_the_App_Store_Badge.png',
                          height: 58,
                          width: 128,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000C40),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, kSupportPath);
                          },
                          child: const Text('Support'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000C40),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, kPrivacyPath);
                          },
                          child: const Text('Privacy'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      translate(
                        'about.footer_description',
                        args: <String, Object?>{'appName': appName},
                      ),
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required String text,
    required TextTheme textTheme,
  }) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '• ',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Expanded(
              child: Text(
                text,
                style: textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildScreenshot(String assetPath) {
    if (assetPath.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            assetPath,
            width: 225,
            height: 450,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
