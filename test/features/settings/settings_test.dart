import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/features/settings/data/settings_repository.dart';
import 'package:github_explorer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsRepository repository;

  Future<SettingsRepository> createRepository([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return SettingsRepository(await SharedPreferences.getInstance());
  }

  setUp(() async => repository = await createRepository());

  test('uses the system locale by default', () {
    expect(SettingsCubit(repository).state.locale, isNull);
  });

  test('restores the saved locale', () async {
    final saved = await createRepository({'locale': 'ru'});

    expect(SettingsCubit(saved).state.locale, const Locale('ru'));
  });

  test('saves the chosen locale and clears it for system default', () async {
    final cubit = SettingsCubit(repository);

    await cubit.setLocale(const Locale('en'));
    expect(cubit.state.locale, const Locale('en'));
    expect(repository.locale, const Locale('en'));

    await cubit.setLocale(null);
    expect(cubit.state.locale, isNull);
    expect(repository.locale, isNull);
  });
}
