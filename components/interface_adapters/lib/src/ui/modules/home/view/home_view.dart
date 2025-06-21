import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/animations/butterfly_animation.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/animations/sakura_petal_animation.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/animations/snow_animation.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/fab.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/language_selector.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/product_info_body.dart';
import 'package:interface_adapters/src/ui/res/color/app_color.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

import 'widgets/interactive_home_prompt.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    // Extract the arguments from the current ModalRoute settings.
    final Object? args = ModalRoute.of(context)?.settings.arguments;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: resources.gradients.unauthorizedConstructionGradient,
      ),
      child: Scaffold(
        extendBody: true,
        // We need to set transparent background explicitly, because
        // Scaffold does not support gradient backgrounds, so we program it
        // to remove any default background, so that the custom background
        // above will be visible.
        backgroundColor: AppColor.cetaceanBlue.value.withAlpha(5),
        // When `resizeToAvoidBottomInset` set to true (which is the default),
        // the Scaffold's body will resize to make space for the keyboard,
        // typically by shrinking its content area.
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        // Add an appBar with the language selector dropdown.
        appBar: AppBar(
          backgroundColor: AppColor.cetaceanBlue.value.withAlpha(5),
          actions: const <Widget>[
            // Use the `LanguageSelector` widget as an action.
            LanguageSelector(),
          ],
        ),
        body: BlocBuilder<HomePresenter, HomeViewModel>(
          builder: (BuildContext _, HomeViewModel viewModel) {
            final String displayText = viewModel is HomeErrorState
                ? viewModel.errorMessage
                : translate('home.scan_barcode');
            return Stack(
              children: <Widget>[
                InteractiveHomePrompt(displayText: displayText),
                if (viewModel is ReadyToScanState &&
                    viewModel.isSeasonalEffectEnabled)
                  if (_isWinter)
                    const SnowAnimation()
                  else if (_isSpring)
                    const SakuraPetalAnimation()
                  else if (_isSummer)
                    const ButterflyAnimation(),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Fab(
          barcode: args is String ? args : '',
          expandedBody: const ProductInfoBody(),
          onPressed: () => context
              .read<HomePresenter>()
              .add(const NavigateToScanViewEvent()),
          onClose: () =>
              context.read<HomePresenter>().add(const ClearProductInfoEvent()),
        ),
      ),
    );
  }

  bool get _isWinter {
    final DateTime currentDate = DateTime.now();
    final int currentMonth = currentDate.month;
    return currentMonth == DateTime.december ||
        currentMonth == DateTime.january ||
        currentMonth == DateTime.february;
  }

  bool get _isSpring {
    final DateTime currentDate = DateTime.now();
    final int currentMonth = currentDate.month;
    return currentMonth == DateTime.march ||
        currentMonth == DateTime.april ||
        currentMonth == DateTime.may;
  }

  bool get _isSummer {
    final DateTime currentDate = DateTime.now();
    final int currentMonth = currentDate.month;
    return currentMonth == DateTime.june ||
        currentMonth == DateTime.july ||
        currentMonth == DateTime.august;
  }
}
