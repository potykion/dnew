import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

late SharedPreferences sp;

class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController() : super(_load()) {}

  static AppSettings _load() {
    String? appSettingsJsonStr = sp.getString("AppSettingsController");
    return appSettingsJsonStr != null
        ? AppSettings.fromJson(
            jsonDecode(appSettingsJsonStr) as Map<String, dynamic>)
        : AppSettings.blank();
  }

  Future<void> update(AppSettings settings) async {
    await sp.setString("AppSettingsController", jsonEncode(settings.toJson()));
    state = settings;
  }

  Future<void> toggleDarkMode() async =>
      await update(state.copyWith(isDarkMode: !state.isDarkMode));

  Future<void> toggleAutoSave() async =>
      await update(state.copyWith(autoSave: !state.autoSave));

  Future<void> toggleDeleteBlank() async =>
      await update(state.copyWith(deleteBlank: !state.deleteBlank));
}

var appSettingsControllerProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>(
  (ref) => AppSettingsController(),
);

var isDarkModeProvider =
    Provider((ref) => ref.watch(appSettingsControllerProvider).isDarkMode);

var themeModeProvider = Provider(
  (ref) => ref.watch(isDarkModeProvider) ? ThemeMode.dark : ThemeMode.light,
);
