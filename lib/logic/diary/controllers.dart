import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dnew/logic/diary/db.dart';
import 'package:dnew/logic/core/utils/dt.dart';
import 'package:dnew/logic/diary/search/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'history/services.dart';
import 'models.dart';

class DiaryRecordController extends StateNotifier<List<DiaryRecord>> {
  final String userId;
  final FirebaseDiaryRecordRepo repo;

  DiaryRecordController({
    required this.repo,
    required this.userId,
  }) : super([]);

  Future<void> getByDate(DateTime date) async {
    state = await repo.listByUserIdAndDate(userId, date);
  }

  Future<String> create(DiaryRecord record) async {
    var id = await repo.insert(record);
    state = [record.copyWith(id: id), ...state];
    return id;
  }

  void resetState() {
    state = [];
  }

  Future<List<DiaryRecord>> getPage({int from = 0, int limit = 10}) async {
    late List<DiaryRecord> items;

    if (state.length >= from + limit) {
      items = state.sublist(from, from + limit);
      if (items.length == limit) return items;
    }

    var fromCreated = state.lastOrNull?.created;
    var fromItems = await repo.listByUserIdPaginated(
      userId,
      limit: limit,
      fromCreated: fromCreated,
    );

    state = [...state, ...fromItems];
    items = state.sublist(from, min(state.length, from + limit));
    return items;
  }

  Future<void> update(DiaryRecord record) async {
    await repo.update(record);
    state = [...state.where((r) => r.id != record.id), record]
      ..sort((r1, r2) => -r1.created.compareTo(r2.created));
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
  (ref) => DiaryRecordController(
    userId: FirebaseAuth.instance.currentUser!.uid,
    repo: ref.watch(diaryRepoProvider),
  ),
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
