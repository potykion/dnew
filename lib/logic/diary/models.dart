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
    @Default(false) bool favourite,
  }) = _DiaryRecord;

  factory DiaryRecord.fromJson(Map<String, dynamic> json) =>
      _$DiaryRecordFromJson(json);

  factory DiaryRecord.blank() => DiaryRecord(
        created: DateTime.now(),
        text: "",
      );
}
