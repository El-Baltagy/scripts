import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/core/storage/hive_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const String _themeKey = 'is_dark_mode';

  void _loadTheme() {
    try {
      final isDark = HiveStorage().readData<bool>(_themeKey, defaultValue: false);
      emit(isDark == true ? ThemeMode.dark : ThemeMode.light);
    } catch (_) {
      emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    try {
      await HiveStorage().writeData<bool>(_themeKey, isDark);
    } catch (_) {}
  }
}
