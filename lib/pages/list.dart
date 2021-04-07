import 'package:dnew/logic/core/controllers.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/routes.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:dnew/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var records = useProvider(diaryRecordListProvider);

    var showFavouriteState = useProvider(showFavouritesProvider);
    var showFavourites = showFavouriteState.state;
    void toggleShowFavourites() {
      showFavouriteState.state = !showFavouriteState.state;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("dnew"),
        actions: [
          IconButton(
            icon: showFavourites
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            onPressed: toggleShowFavourites,
          ),
        ].reversed.toList(),
      ),
      body: records.isEmpty
          ? Center(
              child: showFavourites
                  ? Text("Нет избранных записей")
                  : Text("Нет записей - самое время завести одну"),
            )
          : ListView(
              children: [
                ...records.map((r) => DiaryRecordCard(record: r)),
                // SizedBox(height: 80),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, Routes.form),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
