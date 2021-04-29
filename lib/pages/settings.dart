import 'package:dnew/logic/settings/controllers.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var displayModeStr = useProvider(displayModeStrProvider);
    var isDarkMode = useProvider(isDarkModeProvider);
    var user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading:
                CircleAvatar(backgroundImage: NetworkImage(user.photoURL!)),
            title: Text(user.displayName!),
            subtitle: Text("Подписка активна"),
          ),
          ListTile(
            title: Text("Отображение записей"),
            trailing: Text(
              displayModeStr,
              style: Theme.of(context).textTheme.button,
            ),
            onTap: () => context
                .read(appSettingsControllerProvider.notifier)
                .setNextDisplayMode(),
          ),
          SwitchListTile(
            title: Text("Темная тема"),
            value: isDarkMode,
            onChanged: (_) => context
                .read(appSettingsControllerProvider.notifier)
                .toggleDarkMode(),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
