import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:material_ui/material_ui.dart';

class MarkAsNonFoodDialog extends StatelessWidget {
  const MarkAsNonFoodDialog({required this.barcode, super.key});

  final String barcode;

  static Future<void> show({
    required BuildContext context,
    required String barcode,
  }) {
    final HomePresenter homePresenter = context.read<HomePresenter>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider<HomePresenter>.value(
          value: homePresenter,
          child: MarkAsNonFoodDialog(barcode: barcode),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Resources.of(
            context,
          ).gradients.pinkSunriseGradientBackground,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  translate('product_info.mark_as_non_food_dialog_title'),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  translate('product_info.mark_as_non_food_dialog_content'),
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => _onCancel(context),
                      child: Text(translate('close')),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextButton(
                        onPressed: () => _onConfirm(context),
                        child: Text(
                          translate('product_info.mark_as_non_food_confirm'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onConfirm(BuildContext context) {
    Navigator.of(context).pop();
    context.read<HomePresenter>().add(
      MarkAsNonFoodProductEvent(barcode: barcode),
    );
  }
}
