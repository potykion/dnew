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
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => DiaryRecordCard(record: records[index]),
          childCount: records.length,
        ),
      );
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

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
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
        childCount: groupedRecords.length,
      ),
    );
  }
}
