import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    loadTheme();
  }

  // theme toggle
  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    saveTheme(isDark);
  }

  Future<void> loadTheme() async {
    final preference = await SharedPreferences.getInstance();

    final isDark = preference.getBool('isDarkTheme') ?? false;

    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> saveTheme(bool isDark) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setBool('isDarkTheme', isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
