import 'package:dnew/widgets/bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dnew/logic/core/controllers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var themeModeState = useProvider(themeModeStateProvider);
    var isDarkMode = themeModeState.state == ThemeMode.system
        ? MediaQuery.of(context).platformBrightness == Brightness.dark
        : themeModeState.state == ThemeMode.dark;
    void toggleThemeMode() async {
      themeModeState.state = isDarkMode ? ThemeMode.light : ThemeMode.dark;
      (await SharedPreferences.getInstance()).setBool("isDark", !isDarkMode);
    }

    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Темная тема"),
            value: isDarkMode,
            onChanged: (_) => toggleThemeMode(),
          )
        ],
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
