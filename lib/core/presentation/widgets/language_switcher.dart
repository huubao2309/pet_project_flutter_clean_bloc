import 'package:benny_style/bottom_sheet/benny_bottom_sheet.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../base/app_constants.dart';
import '../../di/injection.dart';

/// A compact language picker shown in the welcome/auth app bar.
///
/// Replaces the GetX-based language dropdown from the source app. Locale
/// changes go through easy_localization ([BuildContext.setLocale]), which also
/// persists the selection. The app-wide rebuild on locale change is handled by
/// keying `MaterialApp.router` (see main.dart), so no manual router refresh is
/// needed here.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  List<Locale> get _locales => AppConstants.supportedLocales;

  @override
  Widget build(BuildContext context) {
    final current = context.locale;
    return TextButton.icon(
      onPressed: () => _showPicker(context),
      icon: const Icon(Icons.language, size: 20),
      label: Text('language.${current.languageCode}'.tr()),
    );
  }

  void _showPicker(BuildContext context) {
    BennyBottomSheet.show(
      content: _LanguageSheet(
        locales: _locales,
        current: context.locale,
      ),
    );
  }
}

/// A simple tap-to-select language list (no scroll wheel), so a single tap on a
/// language applies it immediately.
class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.locales, required this.current});

  final List<Locale> locales;
  final Locale current;

  Future<void> _select(BuildContext context, Locale locale) async {
    // Persist + reload translations while the sheet context is still valid.
    // MaterialApp.router is keyed by locale, so the whole app rebuilds with the
    // new language automatically.
    await context.setLocale(locale);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(theme.spacing.spacing16),
            child: Text(
              'language.title'.tr(),
              style: theme.textStyle.heading
                  .copyWith(color: theme.colors.neutral900),
            ),
          ),
          for (final locale in locales)
            ListTile(
              title: Text('language.${locale.languageCode}'.tr()),
              trailing: locale.languageCode == current.languageCode
                  ? Icon(Icons.check, color: theme.colors.brand500)
                  : null,
              onTap: () => _select(context, locale),
            ),
          SizedBox(height: theme.spacing.spacing16),
        ],
      ),
    );
  }
}
