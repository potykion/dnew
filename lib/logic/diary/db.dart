import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/core/db.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'models.dart';

class FirebaseDiaryRecordRepo extends FirebaseRepo<DiaryRecord> {
  /// Фаерстор репо для привычек
  FirebaseDiaryRecordRepo(
    CollectionReference collectionReference,
  ) : super(
          collectionReference: collectionReference,
        );

  @override
  DiaryRecord entityFromFirebase(DocumentSnapshot doc) {
    var data = doc.data()!;
    data["created"] = (data["created"] as Timestamp).toDate().toIso8601String();
    data["id"] = doc.id;
    return DiaryRecord.fromJson(data);
  }

  @override
  Map<String, dynamic> entityToFirebase(DiaryRecord entity) =>
      entity.toJson()..["created"] = Timestamp.fromDate(entity.created);

  Future<List<DiaryRecord>> listByUserIdPaginated(
    String userId, {
    int limit = 10,
    DateTime? fromCreated,
  }) async {
    var query = await collectionReference
        .where("userId", isEqualTo: userId)
        .orderBy("created", descending: true)
        .limit(limit);
    if (fromCreated != null) {
      query = query.startAfter(<Timestamp>[Timestamp.fromDate(fromCreated)]);
    }

    var docs = (await query.get()).docs;
    return docs.map(entityFromFirebase).toList();
  }
}

var diaryRepoProvider = Provider((_) => FirebaseDiaryRecordRepo(
      FirebaseFirestore.instance.collection("FirebaseDiaryRecordRepo"),
    ));
