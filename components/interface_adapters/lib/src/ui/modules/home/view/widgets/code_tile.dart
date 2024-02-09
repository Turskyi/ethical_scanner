import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class CodeTile extends StatefulWidget {
  const CodeTile({
    super.key,
    required this.value,
  });

  final String value;

  @override
  State<CodeTile> createState() => _CodeTileState();
}

class _CodeTileState extends State<CodeTile> {
  /// Define a controller for the barcode text field
  final TextEditingController _codeController = TextEditingController();
  final ValueNotifier<bool> _editNotifier = ValueNotifier<bool>(false);
  late MaterialColors _colors;
  late TextTheme _textTheme;

  @override
  void initState() {
    super.initState();
    // Set the initial value of the barcode text field
    _codeController.text = widget.value;
  }

  @override
  void didChangeDependencies() {
    _colors = Resources.of(context).colors;
    _textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CodeTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onCodeTextChanged(_codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: _colors.cetaceanBlue,
      iconColor: _colors.cetaceanBlue,
      leading: ValueListenableBuilder<bool>(
        valueListenable: _editNotifier,
        child: const Icon(Icons.star),
        builder: (BuildContext context, bool isEdited, Widget? defaultIcon) {
          return IconButton(
            icon: isEdited
                ? const Icon(Icons.save)
                : (defaultIcon ?? const SizedBox()),
            onPressed: isEdited
                ? () => context.read<HomePresenter>().add(
                      ShowProductInfoEvent(
                        ProductInfo(
                          barcode: _codeController.text,
                          language: Language.fromIsoLanguageCode(
                            LocalizedApp.of(context)
                                .delegate
                                .currentLocale
                                .languageCode,
                          ),
                        ),
                      ),
                    )
                : null,
          );
        },
      ),
      title: Text(
        translate(ProductInfoType.code.key),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _textTheme.titleLarge?.fontSize,
        ),
      ),
      subtitle: TextField(
        controller: _codeController,
        decoration: InputDecoration.collapsed(hintText: _codeController.text),
        onChanged: _onCodeTextChanged,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: _textTheme.bodyLarge?.fontSize,
        ),
      ),
    );
  }

  void _onCodeTextChanged(String text) =>
      _editNotifier.value = text.isNotEmpty && text != widget.value;

  @override
  void dispose() {
    _codeController.dispose();
    _editNotifier.dispose();
    super.dispose();
  }
}
