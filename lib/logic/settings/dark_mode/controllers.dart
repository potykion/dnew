import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system) {
    SharedPreferences.getInstance().then(
      (sp) {
        var isDark = sp.getBool("isDark");
        if (isDark != null) {
          state = isDark ? ThemeMode.dark : ThemeMode.light;
        }
      },
    );
  }

  Future<void> toggle(bool isDarkMode) async {
    state = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    (await SharedPreferences.getInstance()).setBool("isDark", !isDarkMode);
  }
}

var themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);

var isDarkModeProvider = Provider((ref) {
  var themeMode = ref.watch(themeModeControllerProvider);
  var brightness = SchedulerBinding.instance!.window.platformBrightness;
  return themeMode == ThemeMode.system
      ? brightness == Brightness.dark
      : themeMode == ThemeMode.dark;
});
