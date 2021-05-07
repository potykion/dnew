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

  Future<Tuple2<List<DiaryRecord>, DocumentSnapshot>> listByUserIdPaginated(
    String userId, {
    int limit = 20,
    DocumentSnapshot? from,
  }) async {
    var query = await collectionReference
        .where("userId", isEqualTo: userId)
        .orderBy("created", descending: true)
        .limit(limit);
    if (from != null) {
      query = query.startAfterDocument(from);
    }

    var docs = (await query.get()).docs;
    return Tuple2(docs.map(entityFromFirebase).toList(), docs.last);
  }
}

var diaryRepoProvider = Provider((_) => FirebaseDiaryRecordRepo(
      FirebaseFirestore.instance.collection("FirebaseDiaryRecordRepo"),
    ));
