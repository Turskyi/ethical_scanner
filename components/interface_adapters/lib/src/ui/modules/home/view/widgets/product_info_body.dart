import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/delayed_animation.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

class ProductInfoBody extends StatelessWidget {
  const ProductInfoBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Dimens dimens = Resources.of(context).dimens;
    return Container(
      margin: EdgeInsets.only(
        left: dimens.productInfoHorizontalMargin,
        right: dimens.productInfoHorizontalMargin,
        top: kToolbarHeight,
      ),
      child: BlocBuilder<HomePresenter, HomeViewModel>(
        builder: (BuildContext context, HomeViewModel viewModel) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: viewModel.productInfoMap.keys.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == viewModel.productInfoMap.keys.length) {
                if (viewModel is LoadingProductInfoState) {
                  // Return `CircularProgressIndicator` as the last item.
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Resources.of(context).colors.cetaceanBlue,
                        ),
                        strokeWidth: 5.0,
                        backgroundColor: Resources.of(
                          context,
                        ).colors.antiFlashWhite,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                ProductInfoKey key =
                    viewModel.productInfoMap.keys.elementAt(index);
                String value = viewModel.productInfoMap[key] ?? '';
                return DelayedAnimation(
                  delay: index * 150,
                  child: ListTile(
                    textColor: Resources.of(context).colors.cetaceanBlue,
                    iconColor: Resources.of(context).colors.cetaceanBlue,
                    leading: Icon(
                      key == ProductInfoKey.terrorismSponsor
                          ? Icons.question_mark
                          : Icons.star,
                    ),
                    title: Text(
                      key.value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(
                          context,
                        ).textTheme.titleLarge?.fontSize,
                      ),
                    ),
                    subtitle: Text(
                      value +
                          (key.isWebsite || key.isWarSponsor
                              ? ' (Click to know more)'
                              : ''),
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontSize,
                        decoration: key.isWebsite || key.isWarSponsor
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                    onTap: key.isWebsite || key.isWarSponsor
                        ? () => context.read<HomePresenter>().add(
                              LaunchUrlEvent(
                                key.isWarSponsor
                                    ? 'https://sanctions.nazk.gov.ua/en/boycott/'
                                    : value,
                              ),
                            )
                        : null,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
