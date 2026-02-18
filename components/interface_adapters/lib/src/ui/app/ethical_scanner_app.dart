import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class EthicalScannerApp extends StatelessWidget implements App {
  const EthicalScannerApp({
    required this.dependencies,
    required this.localizationDelegate,
    required this.onGenerateRoute,
    super.key,
  });

  final AppDependencies dependencies;
  final LocalizationDelegate localizationDelegate;
  final RouteFactory onGenerateRoute;

  @override
  Widget build(BuildContext _) {
    return BetterFeedback(
      feedbackBuilder:
          (
            BuildContext _,
            OnSubmit onSubmit,
            ScrollController? scrollController,
          ) {
            return FeedbackForm(
              onSubmit: onSubmit,
              scrollController: scrollController,
            );
          },
      theme: FeedbackThemeData(feedbackSheetColor: Colors.grey.shade50),
      child: LocalizedApp(
        localizationDelegate,
        DependenciesScope(
          dependencies: dependencies,
          child: Resources(
            colors: MaterialColors(),
            gradients: Gradients(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: translate('title'),
              onGenerateRoute: onGenerateRoute,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: MaterialColors.primarySwatch,
                ),
                primarySwatch: MaterialColors.primarySwatch,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
