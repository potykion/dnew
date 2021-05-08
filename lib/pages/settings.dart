import 'package:dnew/logic/settings/controllers.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    var settings = useProvider(appSettingsControllerProvider);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading:
                CircleAvatar(backgroundImage: NetworkImage(user.photoURL!)),
            title: Text(user.displayName!),
            subtitle: Text("Подписка активна"),
          ),
          SwitchListTile(
            title: Text("Темная тема"),
            value: settings.isDarkMode,
            onChanged: (_) => context
                .read(appSettingsControllerProvider.notifier)
                .toggleDarkMode(),
          ),
          SwitchListTile(
            title: Text("Автосохранение"),
            value: settings.autoSave,
            onChanged: (_) => context
                .read(appSettingsControllerProvider.notifier)
                .toggleAutoSave(),
          ),
          SwitchListTile(
            title: Text("Удалять пустые записи при запуске"),
            value: settings.deleteBlank,
            onChanged: (_) => context
                .read(appSettingsControllerProvider.notifier)
                .toggleDeleteBlank(),
          )
        ],
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
