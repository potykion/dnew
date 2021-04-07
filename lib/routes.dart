import 'package:dnew/pages/auth.dart';
import 'package:dnew/pages/form.dart';
import 'package:dnew/pages/list.dart';
import 'package:dnew/pages/loading.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class Routes {
  static String loading = "/";
  static String list = "/list";
  static String auth = "/auth";
  static String form = "/form";
}

Map<String, WidgetBuilder> routes = {
  Routes.loading: (_) => LoadingPage(),
  Routes.list: (_) => ListPage(),
  Routes.auth: (_) => AuthPage(),
  Routes.form: (_) => DiaryRecordFormPage(),
};
