import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/search/models.dart';
import 'package:dnew/logic/settings/models.dart';
import 'package:dnew/logic/settings/controllers.dart';
import 'package:dnew/routes.dart';
import 'package:dnew/widgets/loading.dart';
import 'package:dnew/widgets/search_appbar.dart';
import 'package:dnew/widgets/bottom.dart';
import 'package:dnew/widgets/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var searchQuery =
        (ModalRoute.of(context)!.settings.arguments as SearchQuery?) ??
            SearchQuery.text();
    var records = useProvider(diaryRecordListProvider(searchQuery));
    var dailyRecords = useProvider(dailyRecordsProvider(searchQuery));
    var weeklyRecords = useProvider(weeklyRecordsProvider(searchQuery));

    var displayMode = useProvider(displayModeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SearchAppBar(
            searchQuery: searchQuery,
          ),
          // if (records.isEmpty)
          //   SliverToBoxAdapter(
          //     child: SizedBox(
          //       height: MediaQuery.of(context).size.height -
          //           (kToolbarHeight + 10) -
          //           kBottomNavigationBarHeight -
          //           MediaQuery.of(context).padding.top,
          //       child: Center(
          //         child: Text("Записи не найдены"),
          //       ),
          //     ),
          //   ),
          if (displayMode == DiaryRecordDisplayMode.list)
            DiaryRecordList(records: records),
          if (displayMode == DiaryRecordDisplayMode.day)
            GroupedDiaryRecordList(
              groupedRecords: dailyRecords,
              showDate: false,
            ),
          if (displayMode == DiaryRecordDisplayMode.week)
            GroupedDiaryRecordList(groupedRecords: weeklyRecords),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var loadingOverlay = showLoadingOverlay(context);

          var record = DiaryRecord.blank(
            userId: FirebaseAuth.instance.currentUser!.uid,
          );
          record = record.copyWith(
            id: await context
                .read(diaryRecordControllerProvider.notifier)
                .create(record),
          );
          context.read(editableRecordProvider).state = record;

          loadingOverlay.remove();

          Navigator.pushNamed(context, Routes.form);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
