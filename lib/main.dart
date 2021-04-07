import 'package:dnew/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'logic/core/controllers.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  static const MaterialColor palette = MaterialColor(primaryColor, <int, Color>{
    50: Color(0xFFF7F0FF),
    100: Color(0xFFEBDBFE),
    200: Color(0xFFDDC3FE),
    300: Color(0xFFCFAAFD),
    400: Color(0xFFC598FC),
    500: Color(primaryColor),
    600: Color(0xFFB57EFC),
    700: Color(0xFFAC73FB),
    800: Color(0xFFA469FB),
    900: Color(0xFF9656FA),
  });
  static const int primaryColor = 0xFFBB86FC;

  @override
  Widget build(BuildContext context) {
    var themeMode = useProvider(themeModeStateProvider).state;

    return MaterialApp(
      title: 'dnew',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: palette,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: palette,
        accentColor: Color(primaryColor),
        toggleableActiveColor: Color(primaryColor),
      ),
      themeMode: themeMode,
      initialRoute: Routes.loading,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
