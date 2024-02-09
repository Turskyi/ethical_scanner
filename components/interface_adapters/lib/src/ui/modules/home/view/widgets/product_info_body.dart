import 'dart:async';
import 'dart:io';

import 'package:entities/entities.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/code_tile.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/delayed_animation.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/loading_indicator_widget.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/product_info_tile.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class ProductInfoBody extends StatelessWidget {
  const ProductInfoBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Resources resources = Resources.of(context);
    Dimens dimens = resources.dimens;
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
        builder: (_, HomeViewModel viewModel) {
          if (viewModel is ProductInfoState) {
            return RefreshIndicator(
              onRefresh: () =>
                  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                return BetterFeedback.of(context).show((UserFeedback feedback) {
                  return _sendFeedback(feedback, packageInfo);
                });
              }),
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: dimens.productInfoListTopPadding,
                  bottom: dimens.productInfoListBottomPadding,
                ),
                itemCount: viewModel.productInfoMap.keys.length +
                    loadingIndicatorCount,
                itemBuilder: (BuildContext context, int index) {
                  if (index == viewModel.productInfoMap.keys.length) {
                    if (viewModel is LoadingProductInfoState) {
                      // Return `LoadingIndicatorWidget` as the last item.
                      return const LoadingIndicatorWidget();
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    ProductInfoType type =
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
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Future<void> _sendFeedback(UserFeedback feedback, PackageInfo packageInfo) {
    return _writeImageToStorage(feedback.screenshot)
        .then((String screenshotFilePath) {
      return FlutterEmailSender.send(
        Email(
          body: '${feedback.text}\n\n${packageInfo.packageName}\n'
              '${packageInfo.version}\n'
              '${packageInfo.buildNumber}',
          subject: '${translate('app_feedback')}: '
              '${packageInfo.appName}',
          recipients: <String>[Env.openFoodPassword],
          attachmentPaths: <String>[screenshotFilePath],
        ),
      );
    });
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
