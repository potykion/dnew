import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DiaryRecordList extends StatelessWidget {
  final List<DiaryRecord> records;

  const DiaryRecordList({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: records.map((r) => DiaryRecordCard(record: r)).toList(),
    );
  }
}

class DayDiaryRecordList extends HookWidget {
  final Map<DateTime, List<DiaryRecord>> dailyRecords;

  const DayDiaryRecordList({
    Key? key,
    required this.dailyRecords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openedIndexState = useState<int?>(null);

    return ListView.builder(
      itemBuilder: (context, index) {
        var dayRecords = dailyRecords.entries.toList()[index];

        return DateDiaryRecordsCollapse(
          date: dayRecords.key,
          dateRecords: dayRecords.value,
          opened: openedIndexState.value == index,
          onOpenedChange: (opened) {
            if (!opened) {
              openedIndexState.value = null;
            } else {
              openedIndexState.value = index;
            }
          },
        );
      },
      itemCount: dailyRecords.length,
    );
  }
}
