import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/settings_repository.dart';

class SettingsState extends Equatable {
  const SettingsState({this.locale});

  final Locale? locale;

  @override
  List<Object?> get props => [locale];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository)
    : super(SettingsState(locale: _repository.locale));

  final SettingsRepository _repository;

  Future<void> setLocale(Locale? locale) async {
    emit(SettingsState(locale: locale));
    await _repository.saveLocale(locale);
  }
}
