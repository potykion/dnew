import 'package:dnew/logic/core/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

part 'models.g.dart';

@freezed
abstract class DiaryRecord implements _$DiaryRecord, WithId {
  const DiaryRecord._();

  const factory DiaryRecord({
    String? id,
    required DateTime created,
    required String text,
    required String userId,
    @Default(false) bool favourite,
    @Default(<String>[]) List<String> tags,
  }) = _DiaryRecord;

  factory DiaryRecord.fromJson(Map<String, dynamic> json) =>
      _$DiaryRecordFromJson(json);

  factory DiaryRecord.blank({required String userId}) => DiaryRecord(
        userId: userId,
        created: DateTime.now(),
        text: "",
      );
}
