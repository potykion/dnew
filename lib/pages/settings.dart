import 'package:dnew/logic/settings/display_mode/controllers.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dnew/logic/settings/dark_mode/controllers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var displayModeStr = useProvider(displayModeStrProvider);
    var isDarkMode = useProvider(isDarkModeProvider);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text("Отображение записей"),
            trailing: Text(
              displayModeStr,
              style: Theme.of(context).textTheme.button,
            ),
            onTap: () => context
                .read(displayModeControllerProvider.notifier)
                .setNextDisplayMode(),
          ),
          SwitchListTile(
            title: Text("Темная тема"),
            value: isDarkMode,
            onChanged: (_) => context
                .read(themeModeControllerProvider.notifier)
                .toggle(isDarkMode),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
