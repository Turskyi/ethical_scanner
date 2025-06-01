import 'package:entities/entities.dart';
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
            return ListView.builder(
              padding: EdgeInsets.only(
                top: dimens.productInfoListTopPadding,
                bottom: dimens.productInfoListBottomPadding,
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
                  String value = viewModel.productInfoMap[type] ?? '';
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
