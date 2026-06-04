import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/data/local/daos/user_prefs_dao.dart';
import 'package:cliceat_app/core/services/token_service.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  final UserPrefsDao _userPrefsDao;
  final TokenService _tokenService;

  ThemeCubit(this._userPrefsDao, this._tokenService) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final userId = await _tokenService.getUserId();
    if (userId == null) return;

    final prefs = await _userPrefsDao.getPrefs(userId);
    if (prefs?.isDarkMode != null) {
      emit(prefs!.isDarkMode! ? ThemeMode.dark : ThemeMode.light);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final userId = await _tokenService.getUserId();
    if (userId == null) return;

    bool? isDark;
    if (mode == ThemeMode.dark) isDark = true;
    if (mode == ThemeMode.light) isDark = false;

    await _userPrefsDao.setDarkMode(userId, isDark);
    emit(mode);
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}
