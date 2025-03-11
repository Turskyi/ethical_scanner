import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

/// A widget that builds the language selector dropdown.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Language>> languageOptions = Language.values
        .map(
          (Language language) => DropdownMenuItem<Language>(
            alignment: Alignment.center,
            // The value of each item is the language object
            value: language,
            // The child of each item is a row with the flag and the name of the
            // language.
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8.0),
              child: Text(language.flag),
            ),
          ),
        )
        .toList();
    return BlocBuilder<HomePresenter, HomeViewModel>(
      builder: (BuildContext context, HomeViewModel viewModel) {
        final Dimens dimens = Resources.of(context).dimens;
        final Language currentLanguage = viewModel.language;
        return DropdownButton<Language>(
          padding: EdgeInsets.only(left: dimens.leftPadding),
          // The value of the dropdown is the current language.
          value: currentLanguage,

          // The icon of the dropdown is the flag of the current language.
          icon: const Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.white,
          ),
          selectedItemBuilder: (BuildContext context) {
            final List<Center> languageSelectorItems = Language.values
                .map(
                  (Language language) => Center(
                    child: AnimatedSwitcher(
                      duration: Resources.of(
                        context,
                      ).durations.animatedSwitcher,
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) =>
                          FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: Text(
                        key: ValueKey<String>(language.flag),
                        language.flag,
                      ),
                    ),
                  ),
                )
                .toList();
            return currentLanguage.isEnglish
                ? languageSelectorItems
                : languageSelectorItems.reversed.toList();
          },
          underline: const SizedBox(),
          dropdownColor: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(dimens.borderRadius),
          // The items of the dropdown are the supported languages.
          items: currentLanguage.isEnglish
              ? languageOptions
              : languageOptions.reversed.toList(),
          // The onChanged callback is triggered when the user selects a
          // different language.
          onChanged: (Language? language) {
            // Change the language in based on the isoCode of the selected
            // language.
            if (language != null) {
              changeLocale(context, language.isoLanguageCode)
                  // The returned value is always `null`.
                  .then((_) {
                if (context.mounted) {
                  context
                      .read<HomePresenter>()
                      .add(ChangeLanguageEvent(language));
                }
              });
            }
          },
        );
      },
    );
  }
}
