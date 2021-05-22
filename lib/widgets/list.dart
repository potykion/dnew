import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/ads/models.dart';
import 'package:dnew/widgets/ad_card.dart';
import 'package:dnew/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DiaryRecordList extends StatelessWidget {
  final PagingController<int, dynamic> controller;

  const DiaryRecordList({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PagedSliverList<int, dynamic>(
        pagingController: controller,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          itemBuilder: (context, dynamic item, index) {
            if (item is DiaryRecord) {
              return DiaryRecordCard(
                record: item,
                onEdit: controller.refresh,
                onLike: controller.refresh,
              );
            } else if (item is AdMarker) {
              return AdCard(adMarker: item);
            } else {
              throw "хз";
            }
          },
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
