import 'package:entities/entities.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class CodeTile extends StatefulWidget {
  const CodeTile({
    required this.value,
    super.key,
  });

  final String value;

  @override
  State<CodeTile> createState() => _CodeTileState();
}

class _CodeTileState extends State<CodeTile> {
  /// Define a controller for the barcode text field.
  final TextEditingController _codeController = TextEditingController();
  final ValueNotifier<bool> _editNotifier = ValueNotifier<bool>(false);
  bool _isDisposing = false;
  late MaterialColors _colors;
  late TextTheme _textTheme;

  @override
  void initState() {
    super.initState();
    // Set the initial value of the barcode text field.
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
        builder: (BuildContext _, bool isEdited, Widget? defaultIcon) {
          return IconButton(
            icon: isEdited
                ? const Icon(Icons.save)
                : (defaultIcon ?? const SizedBox()),
            onPressed: isEdited ? _saveAndShowProductInfo : null,
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
      trailing: BlocListener<HomePresenter, HomeViewModel>(
        listener: _homeViewModelListener,
        child: IconButton(
          icon: const Icon(Icons.bug_report_outlined),
          onPressed: _onBugReportPressed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposing = true;
    _codeController.dispose();
    _editNotifier.dispose();
    super.dispose();
  }

  void _onCodeTextChanged(String text) {
    _editNotifier.value = text.isNotEmpty && text != widget.value;
  }

  void _onBugReportPressed() {
    context.read<HomePresenter>().add(const BugReportPressedEvent());
  }

  void _homeViewModelListener(BuildContext context, HomeViewModel state) {
    if (state is FeedbackState) {
      _showFeedbackUi();
    } else if (state is FeedbackSent) {
      _notifyFeedbackSent();
    } else if (state is HomeErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFeedbackUi() {
    if (_isDisposing) return;
    BetterFeedback.of(context).show(
      (UserFeedback feedback) {
        if (mounted) {
          context.read<HomePresenter>().add(SubmitFeedbackEvent(feedback));
        }
      },
    );
  }

  void _notifyFeedbackSent() {
    BetterFeedback.of(context).hide();
    // Let user know that his feedback is sent.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your feedback has been sent successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveAndShowProductInfo() {
    final String languageCode = LocalizedApp.of(
      context,
    ).delegate.currentLocale.languageCode;
    final Language language = Language.fromIsoLanguageCode(
      languageCode,
    );
    context.read<HomePresenter>().add(
          ShowProductInfoEvent(
            ProductInfo(
              barcode: _codeController.text,
              language: language,
            ),
          ),
        );
  }
}
