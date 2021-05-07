import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dnew/logic/diary/db.dart';
import 'package:dnew/logic/core/utils/dt.dart';
import 'package:dnew/logic/diary/search/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'history/services.dart';
import 'models.dart';

class DiaryRecordController extends StateNotifier<List<DiaryRecord>> {
  final FirebaseDiaryRecordRepo repo;

  DiaryRecordController(this.repo) : super([]);

  Future<String> create(DiaryRecord record) async {
    var id = await repo.insert(record);
    state = [...state, record.copyWith(id: id)];
    return id;
  }

  Future<void> listByUserId(String userId) async {
    state = await repo.listByUserId(userId);
  }

  Future<void> update(DiaryRecord record) async {
    await repo.update(record);
    state = [...state.where((r) => r.id != record.id), record];
  }

  Future<void> toggleFavourite(DiaryRecord record) async {
    record = record.copyWith(favourite: !record.favourite);
    await update(record);
  }

  Future<void> delete(DiaryRecord record) async {
    await repo.deleteById(record.id!);
    state = [...state.where((r) => r.id != record.id)];
  }

  Future<void> deleteBlank() async {
    var blankRecordIds =
        state.where((r) => r.text == "").map((r) => r.id!).toSet();
    await Future.wait(blankRecordIds.map(repo.deleteById));
    state = [...state.where((r) => !blankRecordIds.contains(r.id))];
  }
}


var diaryRecordControllerProvider =
    StateNotifierProvider<DiaryRecordController, List<DiaryRecord>>(
  (ref) => DiaryRecordController(ref.watch(diaryRepoProvider)),
);

ProviderFamily<List<DiaryRecord>, SearchQuery> diaryRecordListProvider =
    Provider.family(
  (ref, query) => ref
      .watch(diaryRecordControllerProvider)
      .where(
        (r) => query.when(
            text: (text) => r.text.toLowerCase().contains(text.toLowerCase()),
            tag: (tag) => r.tags.contains(tag),
            favourite: () => r.favourite),
      )
      .toList()
        ..sort((r1, r2) => -r1.created.compareTo(r2.created)),
);
ProviderFamily<Map<String, List<DiaryRecord>>, SearchQuery>
    dailyRecordsProvider = Provider.family((ref, tag) {
  return groupBy<DiaryRecord, String>(
    ref.watch(diaryRecordListProvider(tag)),
    (r) {
      var recordCreatedDate = r.created.date();
      return DateFormat.yMd().format(recordCreatedDate);
    },
  );
});
ProviderFamily<Map<String, List<DiaryRecord>>, SearchQuery>
    weeklyRecordsProvider = Provider.family((ref, tag) {
  return groupBy<DiaryRecord, String>(
    ref.watch(diaryRecordListProvider(tag)),
    (r) {
      var recordWeek = DateRange.withinWeek(r.created);
      var fromDateStr = DateFormat.yMd().format(recordWeek.from);
      var toDateStr = DateFormat.yMd().format(recordWeek.to);
      return "$fromDateStr - $toDateStr";
    },
  );
});

var tagsProvider = Provider(
  (ref) => ref
      .watch(diaryRecordControllerProvider)
      .expand((r) => r.tags)
      .toList()
      .reversed
      .toSet(),
);

ProviderFamily<Iterable<String>, String> searchTagsProvider = Provider.family(
  (ref, tagPattern) => ref
      .watch(tagsProvider)
      .where((t) => t.toLowerCase().contains(tagPattern.toLowerCase())),
);

var editableRecordProvider = StateProvider(
  (ref) => DiaryRecord.blank(
    userId: FirebaseAuth.instance.currentUser!.uid,
  ),
);

var historyProvider = Provider((_) => History());
