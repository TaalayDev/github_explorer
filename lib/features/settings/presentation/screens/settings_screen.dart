import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/language_option.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = context.select(
      (SettingsCubit cubit) => cubit.state.locale?.languageCode,
    );
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.languageTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.extraColors.textSecondaryColor,
              ),
            ),
          ),
          LanguageOption(
            title: l10n.languageSystem,
            isSelected: selected == null,
            onTap: () => cubit.setLocale(null),
          ),
          LanguageOption(
            title: 'English',
            isSelected: selected == 'en',
            onTap: () => cubit.setLocale(const Locale('en')),
          ),
          LanguageOption(
            title: 'Русский',
            isSelected: selected == 'ru',
            onTap: () => cubit.setLocale(const Locale('ru')),
          ),
        ],
      ),
    );
  }
}
