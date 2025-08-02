import 'dart:io';

import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/animations/delayed_animation.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/code_tile.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/loading_indicator_widget.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/product_info_tile.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

class ProductInfoBody extends StatelessWidget {
  const ProductInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final Dimens dimens = resources.dimens;
    // Define a constant for the purpose of the additional count.
    const int loadingIndicatorCount = 1;
    // Define a constant for the animation delay.
    const int animationDelay = 150;
    return Container(
      margin: EdgeInsets.only(
        right: dimens.productInfoHorizontalMargin,
        top: kToolbarHeight,
      ),
      child: BlocBuilder<HomePresenter, HomeViewModel>(
        builder: (BuildContext _, HomeViewModel viewModel) {
          if (viewModel is ProductInfoState) {
            final EdgeInsets edgeInsets = MediaQuery.viewInsetsOf(context);
            final EdgeInsets padding = MediaQuery.paddingOf(context);

            const double androidSpecificTopAdjustment = 16.0;
            const double defaultPlatformTopAdjustment = 0.0;

            // Determine platform-specific adjustment in a web-safe way
            double platformSpecificBasePadding;
            if (kIsWeb) {
              platformSpecificBasePadding = defaultPlatformTopAdjustment;
            } else if (Platform.isAndroid) {
              platformSpecificBasePadding = androidSpecificTopAdjustment;
            } else {
              platformSpecificBasePadding = defaultPlatformTopAdjustment;
            }

            return ListView.builder(
              padding: EdgeInsets.only(
                top: platformSpecificBasePadding +
                    padding.top +
                    edgeInsets.top +
                    // Without it the code tile will be pushed up outside of the
                    // window screen when the keyboard is opened, without
                    // ability to scroll down. What it does is adds the padding
                    // on top of the size of the keyboard, so this way code
                    // tile remains on the same place.
                    edgeInsets.bottom,
                bottom: dimens.productInfoListBottomPadding +
                    padding.bottom +
                    edgeInsets.bottom,
              ),
              itemCount:
                  viewModel.productInfoMap.keys.length + loadingIndicatorCount,
              itemBuilder: (BuildContext context, int index) {
                if (index == viewModel.productInfoMap.keys.length) {
                  if (viewModel is LoadingProductInfoState) {
                    // Return `LoadingIndicatorWidget` as the last item.
                    return const LoadingIndicatorWidget();
                  } else {
                    return const SizedBox();
                  }
                } else {
                  final ProductInfoType type =
                      viewModel.productInfoMap.keys.elementAt(
                    index,
                  );
                  final String value = viewModel.productInfoMap[type] ?? '';
                  return DelayedAnimation(
                    delay: index * animationDelay,
                    child: type.isCode
                        ? CodeTile(value: value)
                        : ProductInfoTile(
                            type: type,
                            value: value,
                            info: viewModel.productInfo,
                          ),
                  );
                }
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
