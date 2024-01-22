import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_event.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/fab.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/product_info_body.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/snow_animation.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/offsets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: Resources.of(
          context,
        ).gradients.unauthorizedConstructionGradient,
      ),
      child: Scaffold(
        // We need to set transparent background explicitly, because Scaffold
        // does not support gradient backgrounds, so we program it to remove
        // any default background, so that the custom background above will be
        // visible.
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Center(
              heightFactor: Resources.of(context).dimens.bodyHeightFactor,
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
                      Resources.of(context).colors.columbiaBlue,
                      Resources.of(context).colors.verdigris,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: BlocBuilder<HomePresenter, HomeViewModel>(
                    builder: (BuildContext context, HomeViewModel viewModel) =>
                        Text(
                      viewModel is HomeErrorState
                          ? viewModel.errorMessage
                          : translate('home.scan_barcode'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: Resources.of(
                              context,
                            ).dimens.bodyBlurRadius,
                            color: Colors.black,
                            offset: Offsets.bodyTitleOffset,
                          ),
                        ],
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<HomePresenter, HomeViewModel>(
              builder: (BuildContext context, HomeViewModel viewModel) {
                if (viewModel is ReadyToScanState &&
                    viewModel.isPrecipitationFalls) {
                  return const SnowAnimation();
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<HomePresenter, HomeViewModel>(
          builder: (BuildContext context, HomeViewModel viewModel) => Fab(
            expandedBody: const ProductInfoBody(),
            onPressed: () => context
                .read<HomePresenter>()
                .add(const NavigateToScanViewEvent()),
            onClose: () => context
                .read<HomePresenter>()
                .add(const ClearProductInfoEvent()),
          ),
        ),
      ),
    );
  }
}
