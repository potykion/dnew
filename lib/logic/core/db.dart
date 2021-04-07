import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

/// Создает Firebase батч - типа транзакция
/// Обычно используется это: FirebaseFirestore.instance.batch
typedef CreateBatch = WriteBatch Function();

/// Firebase / Firestore репо
abstract class FirebaseRepo<T extends WithId> {
  /// Фаерстор коллекция
  @protected
  @visibleForTesting
  final CollectionReference collectionReference;

  /// Firebase Firestore репо
  FirebaseRepo({
    required this.collectionReference,
  });

  /// Конвертит сущность в фаерстор формат
  @protected
  Map<String, dynamic> entityToFirebase(T entity);

  /// Создает сущность из фаерстор дока
  @protected
  T entityFromFirebase(DocumentSnapshot doc);

  /// Вставляет сущность в фаерстор
  Future<String> insert(T entity) async =>
      (await collectionReference.add(entityToFirebase(entity))).id;

  /// Обновляет сущность в фаерстор
  Future<void> update(T entity) =>
      collectionReference.doc(entity.id).update(entityToFirebase(entity));

  /// Удаляет сущность в фаерстор по айди
  Future<void> deleteById(String id) => collectionReference.doc(id).delete();

  /// Получает сущность из фаерстор по айди
  Future<T> get(String id) async =>
      entityFromFirebase((await collectionReference.doc(id).get()));

  /// Получает все сущности из фаерстор
  Future<List<T>> listByUserId(String userId) async =>
      (await collectionReference.where("userId", isEqualTo: userId).get())
          .docs
          .map(entityFromFirebase)
          .toList();
}
