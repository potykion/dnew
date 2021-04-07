import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

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

class GroupedDiaryRecordList extends HookWidget {
  final Map<String, List<DiaryRecord>> groupedRecords;
  final bool showDate;

  const GroupedDiaryRecordList({
    Key? key,
    required this.groupedRecords,
    this.showDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openedIndexState = useState<int?>(0);

    return ListView.builder(
      itemBuilder: (context, index) {
        var dayRecords = [...groupedRecords.entries][index];

        return DiaryRecordsCollapse(
          label: dayRecords.key,
          dateRecords: dayRecords.value,
          opened: openedIndexState.value == index,
          onOpenedChange: (opened) {
            openedIndexState.value = opened ? index : null;
          },
          showDate: showDate,
        );
      },
      itemCount: groupedRecords.length,
    );
  }
}
