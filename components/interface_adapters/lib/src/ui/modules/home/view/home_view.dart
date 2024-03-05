import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/fab.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/language_selector.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/product_info_body.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/snow_animation.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Resources resources = Resources.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: resources.gradients.unauthorizedConstructionGradient,
      ),
      child: BlocBuilder<HomePresenter, HomeViewModel>(
        builder: (BuildContext context, HomeViewModel viewModel) {
          MaterialColors colors = resources.colors;
          Dimens dimens = resources.dimens;
          String displayText = viewModel is HomeErrorState
              ? viewModel.errorMessage
              : translate('home.scan_barcode');
          return Scaffold(
            // We need to set transparent background explicitly, because
            // Scaffold does not support gradient backgrounds, so we program it
            // to remove any default background, so that the custom background
            // above will be visible.
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: viewModel is! ProductInfoState,
            extendBodyBehindAppBar: viewModel is ReadyToScanState,
            // Add an appBar with the language selector dropdown
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: const <Widget>[
                // Use the `LanguageSelector` widget as an action.
                LanguageSelector(),
              ],
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: dimens.bodyBottomMargin),
                  child: GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      double? primaryVelocity = details.primaryVelocity;
                      if (primaryVelocity != null && primaryVelocity > 0) {
                        context
                            .read<HomePresenter>()
                            .add(const PrecipitationToggleEvent());
                      }
                    },
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) => LinearGradient(
                        colors: <Color>[
                          colors.columbiaBlue,
                          colors.verdigris,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: AnimatedSwitcher(
                        duration: resources.durations.animatedSwitcher,
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) =>
                            FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        child: Text(
                          displayText,
                          key: ValueKey<String>(displayText),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.headlineLarge?.fontSize,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                blurRadius: dimens.bodyBlurRadius,
                                color: Colors.black,
                                offset: Offset(
                                  dimens.bodyTitleOffset,
                                  dimens.bodyTitleOffset,
                                ),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (viewModel is ReadyToScanState &&
                    viewModel.isPrecipitationFalls)
                  if (_isWinter) const SnowAnimation(),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Fab(
              expandedBody: const ProductInfoBody(),
              onPressed: () => context
                  .read<HomePresenter>()
                  .add(const NavigateToScanViewEvent()),
              onClose: () => context
                  .read<HomePresenter>()
                  .add(const ClearProductInfoEvent()),
            ),
          );
        },
      ),
    );
  }

  bool get _isWinter {
    DateTime currentDate = DateTime.now();
    int currentMonth = currentDate.month;
    return currentMonth == DateTime.december ||
        currentMonth == DateTime.january ||
        currentMonth == DateTime.february;
  }
}
