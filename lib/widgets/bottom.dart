import 'package:dnew/routes.dart';
import 'package:dnew/logic/core/utils/map.dart';
import 'package:flutter/material.dart';

class MyBottomNav extends StatelessWidget {
  static Map<int, String> navRoutes = {
    0: Routes.list,
    1: Routes.settings,
  };

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navRoutes.keyByValue(
        ModalRoute.of(context)!.settings.name!,
      )!,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Записи"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Настройки"),
      ],
      onTap: (index) {
        Navigator.pushReplacementNamed(context, navRoutes[index]!);
      },
    );
  }
}
