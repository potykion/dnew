import 'package:dnew/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dnew',
      theme: ThemeData(),
      initialRoute: Routes.loading,
      routes: routes,
    );
  }
}
