import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dnew/logic/diary/db.dart';
import 'package:dnew/logic/core/utils/dt.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'models.dart';

class DiaryRecordController extends StateNotifier<List<DiaryRecord>> {
  final FirebaseDiaryRecordRepo repo;

  DiaryRecordController(this.repo) : super([]);

  Future<void> create(DiaryRecord record) async {
    state = [
      ...state,
      record.copyWith(id: await repo.insert(record)),
    ];
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
}

var diaryRepoProvider = Provider((_) => FirebaseDiaryRecordRepo(
      FirebaseFirestore.instance.collection("FirebaseDiaryRecordRepo"),
    ));

var diaryRecordControllerProvider =
    StateNotifierProvider<DiaryRecordController, List<DiaryRecord>>(
  (ref) => DiaryRecordController(ref.watch(diaryRepoProvider)),
);

var showFavouritesProvider = StateProvider((ref) => false);

ProviderFamily<List<DiaryRecord>, String?> diaryRecordListProvider =
    Provider.family(
  (ref, tag) => ref
      .watch(diaryRecordControllerProvider)
      .where(
        (r) =>
            (ref.watch(showFavouritesProvider).state && r.favourite) ||
            !ref.watch(showFavouritesProvider).state,
      )
      .where((r) => tag == null || r.tags.contains(tag))
      .toList()
        ..sort((r1, r2) => -r1.created.compareTo(r2.created)),
);
ProviderFamily<Map<String, List<DiaryRecord>>, String?> dailyRecordsProvider =
    Provider.family((ref, tag) {
  return groupBy<DiaryRecord, String>(
    ref.watch(diaryRecordListProvider(tag)),
    (r) {
      var recordCreatedDate = r.created.date();
      return DateFormat.yMd().format(recordCreatedDate);
    },
  );
});
ProviderFamily<Map<String, List<DiaryRecord>>, String?> weeklyRecordsProvider =
    Provider.family((ref, tag) {
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
  (ref) =>
      ref.watch(diaryRecordControllerProvider).expand((r) => r.tags).toSet(),
);

ProviderFamily<Iterable<String>, String> searchTagsProvider = Provider.family(
  (ref, tagPattern) => ref
      .watch(tagsProvider)
      .where((t) => t.toLowerCase().contains(tagPattern.toLowerCase())),
);
