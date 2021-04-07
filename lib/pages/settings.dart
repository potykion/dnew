import 'package:dnew/widgets/bottom.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("SettingsPage"),
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
