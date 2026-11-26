import 'package:entities/entities.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/services/widget_pin_service.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
import 'package:material_ui/material_ui.dart';

/// The [AndroidHomeAppBarActions] provides the vertical three-dots popup menu
/// on the Android home screen app bar, containing options for changing language
/// and pinning the home widget.
class AndroidHomeAppBarActions extends StatelessWidget {
  const AndroidHomeAppBarActions({
    required this.currentLanguage,
    required this.onLanguageSelected,
    super.key,
  });

  final Language currentLanguage;
  final ValueChanged<Language> onLanguageSelected;

  static const String _actionLanguage = 'language';
  static const String _actionPinWidget = 'pin_widget';

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final Dimens dimens = resources.dimens;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimens.borderRadius),
      ),
      onSelected: (String value) {
        if (value == _actionLanguage) {
          _showLanguageDialog(context);
        } else if (value == _actionPinWidget) {
          _handlePinWidget(context);
        } else {
          // Unknown action, do nothing
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: _actionLanguage,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(currentLanguage.flag),
                ),
                Text(
                  translate('menu.language'),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: _actionPinWidget,
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.push_pin_outlined, color: Colors.white),
                ),
                Text(
                  translate('menu.pin_widget'),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(translate('menu.language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Language.values.map((Language language) {
              return ListTile(
                leading: Text(language.flag),
                title: Text(translate('languages.${language.isoLanguageCode}')),
                selected: language == currentLanguage,
                onTap: () async {
                  await changeLocale(dialogContext, language.isoLanguageCode);
                  if (dialogContext.mounted) {
                    onLanguageSelected(language);
                    Navigator.of(dialogContext).pop();
                  } else {
                    // Context not mounted, do nothing
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _handlePinWidget(BuildContext context) async {
    const WidgetPinService widgetPinService = WidgetPinService();
    final bool success = await widgetPinService.pinWidget();
    if (context.mounted) {
      final String message = success
          ? translate('home.pin_widget_success')
          : translate('home.pin_widget_not_supported');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      // Context not mounted, do nothing
    }
  }
}
