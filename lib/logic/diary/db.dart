import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/core/db.dart';

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
}
