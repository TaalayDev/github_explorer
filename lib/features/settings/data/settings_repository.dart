import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  const SettingsRepository(this._preferences);

  static const _localeKey = 'locale';

  final SharedPreferences _preferences;

  Locale? get locale {
    final languageCode = _preferences.getString(_localeKey);
    return languageCode == null ? null : Locale(languageCode);
  }

  Future<void> saveLocale(Locale? locale) async {
    if (locale == null) {
      await _preferences.remove(_localeKey);
    } else {
      await _preferences.setString(_localeKey, locale.languageCode);
    }
  }
}
