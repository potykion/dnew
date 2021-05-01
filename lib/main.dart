import 'package:dnew/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/settings/controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
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
    var themeMode = useProvider(themeModeProvider);

    return MaterialApp(
      title: 'dnew',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
        textTheme: TextTheme(button: TextStyle(color: Colors.deepPurple)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: palette,
        accentColor: Color(primaryColor),
        toggleableActiveColor: Color(primaryColor),
        textTheme: TextTheme(button: TextStyle(color: Color(primaryColor))),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
      ),
      themeMode: themeMode,
      initialRoute: Routes.loading,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
