import 'package:dnew/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'logic/core/controllers.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var themeMode = useProvider(themeModeStateProvider).state;

    return MaterialApp(
      title: 'dnew',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Color(0xffBB86FC),
      ),
      themeMode: themeMode,
      initialRoute: Routes.loading,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
