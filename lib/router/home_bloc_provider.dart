import 'package:entities/entities.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:ethical_scanner/di/dependencies_scope.dart';
import 'package:ethical_scanner/router/routes.dart' as route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';

class HomeBlocProvider extends StatelessWidget {
  const HomeBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePresenter>(
      create: (BuildContext context) {
        Dependencies dependencies = DependenciesScope.of(context);
        return HomePresenter(
          dependencies.productInfoUseCase,
          dependencies.savePrecipitationStateUseCase,
          dependencies.getPrecipitationStateUseCase,
          dependencies.saveLanguageUseCase,
          dependencies.getLanguageUseCase,
        )..add(const LoadHomeEvent());
      },
      child: BlocListener<HomePresenter, HomeViewModel>(
        listener: (BuildContext context, HomeViewModel viewModel) {
          Language language = Language.fromIsoLanguageCode(
            viewModel.language.isoLanguageCode,
          );
          if (viewModel is ScanState) {
            Navigator.pushNamed<String>(context, route.scanPath).then(
              (String? barcode) {
                _displayProductInfoOrHome(
                  context: context,
                  productInfo: ProductInfo(
                    barcode: barcode ?? '',
                    language: language,
                  ),
                );
              },
            );
          } else if (viewModel is PhotoMakerState) {
            Navigator.pushNamed<void>(
              context,
              route.photoPath,
              arguments: viewModel.productInfo,
            ).then(
              (_) => context.read<HomePresenter>().add(
                    const ClearProductInfoEvent(),
                  ),
            );
          } else if (viewModel is ReadyToScanState) {
            Language currentLanguage = Language.fromIsoLanguageCode(
              LocalizedApp.of(context).delegate.currentLocale.languageCode,
            );
            Language savedLanguage = viewModel.language;
            if (currentLanguage != savedLanguage) {
              changeLocale(context, savedLanguage.isoLanguageCode)
                  // The returned value in `then` is always `null`.
                  .then((_) {
                context
                    .read<HomePresenter>()
                    .add(ChangeLanguageEvent(savedLanguage));
              });
            }
          }
        },
        child: const HomeView(),
      ),
    );
  }

  void _displayProductInfoOrHome({
    required BuildContext context,
    required ProductInfo productInfo,
  }) {
    if (productInfo.barcode.isNotEmpty) {
      context.read<HomePresenter>().add(ShowProductInfoEvent(productInfo));
    } else {
      context.read<HomePresenter>().add(const ClearProductInfoEvent());
    }
  }
}
