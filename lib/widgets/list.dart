import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/diary/db.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/widgets/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DiaryRecordList extends HookWidget {
  final List<DiaryRecord> records;

  const DiaryRecordList({
    Key? key,
    required this.records,
  }) : super(key: key);

  static const _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    var pagingController = useMemoized(
      () =>
          PagingController<DocumentSnapshot?, DiaryRecord>(firstPageKey: null),
    );
    useEffect(
      () {
        Future<void> fetchPage(DocumentSnapshot? pageKey) async {
          try {
            final itemsAndCursor =
                await context.read(diaryRepoProvider).listByUserIdPaginated(
                      FirebaseAuth.instance.currentUser!.uid,
                      from: pageKey,
                      limit: _pageSize,
                    );
            var items = itemsAndCursor.item1;
            var cursor = itemsAndCursor.item2;

            final isLastPage = items.length < _pageSize;
            if (isLastPage) {
              pagingController.appendLastPage(items);
            } else {
              pagingController.appendPage(items, cursor);
            }
          } catch (error) {
            pagingController.error = error;
          }
        }

        pagingController.addPageRequestListener(fetchPage);
        return pagingController.dispose;
      },
      [],
    );

    return PagedSliverList<DocumentSnapshot?, DiaryRecord>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<DiaryRecord>(
        itemBuilder: (context, item, index) => DiaryRecordCard(record: item),
      ),
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
