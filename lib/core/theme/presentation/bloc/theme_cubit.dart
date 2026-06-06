import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/data/local/daos/user_prefs_dao.dart';
import 'package:cliceat_app/core/services/token_service.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(
    UserPrefsDao userPrefsDao,
    TokenService tokenService,
  ) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    emit(ThemeMode.light);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    emit(ThemeMode.light);
  }
}
