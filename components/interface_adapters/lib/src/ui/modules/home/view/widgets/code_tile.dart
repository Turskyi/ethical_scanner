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
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

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
      trailing: IconButton(
        icon: const Icon(Icons.bug_report_outlined),
        onPressed: _onBugReportPressed,
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _editNotifier.dispose();
    super.dispose();
  }

  void _onCodeTextChanged(String text) =>
      _editNotifier.value = text.isNotEmpty && text != widget.value;

  Future<void> _onBugReportPressed() => PackageInfo.fromPlatform().then(
        (PackageInfo packageInfo) {
          if (mounted) {
            BetterFeedback.of(context).show(
              (UserFeedback feedback) => _sendFeedback(
                feedback: feedback,
                packageInfo: packageInfo,
              ),
            );
          }
        },
      );

  Future<void> _sendFeedback({
    required UserFeedback feedback,
    required PackageInfo packageInfo,
  }) =>
      _writeImageToStorage(feedback.screenshot)
          .then((String screenshotFilePath) {
        return FlutterEmailSender.send(
          Email(
            body: '${feedback.text}\n\nApp id: ${packageInfo.packageName}\n'
                'App version: ${packageInfo.version}\n'
                'Build number: ${packageInfo.buildNumber}',
            subject: '${translate('app_feedback')}: '
                '${packageInfo.appName}',
            recipients: <String>[Env.supportEmail],
            attachmentPaths: <String>[screenshotFilePath],
          ),
        );
      });

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
