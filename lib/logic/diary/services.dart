import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/diary/db.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  Future<void> list() async {
    state = await repo.list();
  }

  Future<void> update(DiaryRecord record) async {
    await repo.update(record);
    state = [...state.where((r) => r.id != record.id), record];
  }

  Future<void> delete(DiaryRecord record) async {
    await repo.deleteById(record.id!);
    state = [...state.where((r) => r.id != record.id)];
  }
}

var diaryRecordControllerProvider = StateNotifierProvider(
  (_) => DiaryRecordController(
    FirebaseDiaryRecordRepo(
      FirebaseFirestore.instance.collection("FirebaseDiaryRecordRepo"),
    ),
  ),
);
