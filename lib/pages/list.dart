import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/settings/display_mode/controllers.dart';
import 'package:dnew/logic/settings/display_mode/models.dart';
import 'package:dnew/routes.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:dnew/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var tag = ModalRoute.of(context)!.settings.arguments as String?;
    var records = useProvider(diaryRecordListProvider(tag));
    var dailyRecords = useProvider(dailyRecordsProvider(tag));
    var weeklyRecords = useProvider(weeklyRecordsProvider(tag));

    var displayMode = useProvider(displayModeControllerProvider);

    var showFavouriteState = useProvider(showFavouritesProvider);
    var showFavourites = showFavouriteState.state;
    void toggleShowFavourites() {
      showFavouriteState.state = !showFavouriteState.state;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tag ?? "dnew"),
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
          : displayMode == DiaryRecordDisplayMode.list
              ? DiaryRecordList(records: records)
              : displayMode == DiaryRecordDisplayMode.day
                  ? GroupedDiaryRecordList(
                      groupedRecords: dailyRecords,
                      showDate: false,
                    )
                  : displayMode == DiaryRecordDisplayMode.week
                      ? GroupedDiaryRecordList(groupedRecords: weeklyRecords)
                      : null,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, Routes.form),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
