import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/home_presenter.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class EditProductDetailsDialog extends StatefulWidget {
  const EditProductDetailsDialog({
    required this.barcode,
    required this.currentName,
    required this.canHaveIngredients,
    super.key,
  });

  final String barcode;
  final String currentName;
  final bool canHaveIngredients;

  static Future<void> show({
    required BuildContext context,
    required String barcode,
    required String currentName,
    required bool canHaveIngredients,
  }) {
    final HomePresenter homePresenter = context.read<HomePresenter>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider<HomePresenter>.value(
          value: homePresenter,
          child: EditProductDetailsDialog(
            barcode: barcode,
            currentName: currentName,
            canHaveIngredients: canHaveIngredients,
          ),
        );
      },
    );
  }

  @override
  State<EditProductDetailsDialog> createState() =>
      _EditProductDetailsDialogState();
}

class _EditProductDetailsDialogState extends State<EditProductDetailsDialog> {
  late final TextEditingController _nameController;
  late bool _canHaveIngredients;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _canHaveIngredients = widget.canHaveIngredients;
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
          constraints: const BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  translate('product_info.edit_product_details'),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: translate('product_info.product_name_label'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  translate('product_info.product_type_label'),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RadioGroup<bool>(
                  groupValue: _canHaveIngredients,
                  onChanged: _setCanHaveIngredients,
                  child: Column(
                    children: <Widget>[
                      RadioListTile<bool>(
                        title: Text(
                          translate('product_info.can_have_ingredients'),
                        ),
                        value: true,
                      ),
                      RadioListTile<bool>(
                        title: Text(
                          translate('product_info.cannot_have_ingredients'),
                        ),
                        value: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text(translate('close')),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<HomePresenter>().add(
                          UpdateProductDetailsEvent(
                            barcode: widget.barcode,
                            productName: _nameController.text.trim(),
                            canHaveIngredients: _canHaveIngredients,
                          ),
                        );
                      },
                      child: Text(translate('save')),
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _setCanHaveIngredients(bool? value) {
    if (value != null) {
      setState(() {
        _canHaveIngredients = value;
      });
    }
  }
}
