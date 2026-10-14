import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class VegetarianCheckDialog extends StatefulWidget {
  const VegetarianCheckDialog({
    required this.response,
    required this.barcode,
    super.key,
  });

  final AiVegetarianCheckResponse response;
  final String barcode;

  static Future<void> show({
    required BuildContext context,
    required AiVegetarianCheckResponse response,
    required String barcode,
  }) {
    final HomePresenter homePresenter = context.read<HomePresenter>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider<HomePresenter>.value(
          value: homePresenter,
          child: VegetarianCheckDialog(response: response, barcode: barcode),
        );
      },
    );
  }

  @override
  State<VegetarianCheckDialog> createState() => _VegetarianCheckDialogState();
}

class _VegetarianCheckDialogState extends State<VegetarianCheckDialog> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final LinearGradient backgroundGradient =
        resources.gradients.pinkSunriseGradientBackground;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final bool isVegetarian = widget.response.isVegetarian;

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isVegetarian
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_outlined,
                  color: isVegetarian
                      ? Colors.green.shade700
                      : Colors.orange.shade800,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  translate('product_info.vegetarian_check_title'),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  isVegetarian
                      ? translate('product_info.vegetarian_check_is_vegetarian')
                      : translate(
                          'product_info.vegetarian_check_not_vegetarian',
                        ),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isVegetarian
                        ? Colors.green.shade900
                        : Colors.red.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  translate(
                    'product_info.ai_vegetarian_reason',
                    args: <String, Object?>{'reason': widget.response.reason},
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.response.model.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    translate(
                      'product_info.ai_model',
                      args: <String, Object?>{'model': widget.response.model},
                    ),
                    style: textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                ],
                const SizedBox(height: 20),
                if (isVegetarian) ...<Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () => _onContributePressed(context),
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(
                        _isSubmitting
                            ? translate('product_info.contributing_to_off')
                            : translate('product_info.contribute_to_off'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                TextButton(
                  onPressed: _isSubmitting ? null : Navigator.of(context).pop,
                  child: Text(translate('close')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onContributePressed(BuildContext context) {
    setState(() {
      _isSubmitting = true;
    });

    context.read<HomePresenter>().add(
      ContributeVegetarianLabelEvent(barcode: widget.barcode),
    );
  }
}
