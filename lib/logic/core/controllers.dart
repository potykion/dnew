import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

var isDarkProvider = FutureProvider<bool?>((_) async {
  return (await SharedPreferences.getInstance()).getBool("isDark");
});

var themeModeStateProvider = StateProvider((ref) {
  return ref.watch(isDarkProvider).maybeWhen(
        data: (isDark) => isDark == null
            ? ThemeMode.system
            : isDark
                ? ThemeMode.dark
                : ThemeMode.light,
        orElse: () => ThemeMode.system,
      );
});
