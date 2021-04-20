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

  bool isTextOverflow(
    double screenWidth, [
    double maxHeight = 300,
    double charWidth = 7,
    double lineHeight = 16,
  ]) {
    // Если есть картинка, то оверфлоу
    if (RegExp(r"!\[.*?\]\(.+\)").hasMatch(text)) return true;

    // 19 строк = 296 пх
    // 51 символов помещается в одной строке =  368 пх => 8 пх - 1 сим.
    var lines = text.split("\n");
    var screenLines = lines
        .map((line) => (line.length * charWidth / screenWidth).floor() + 1)
        .reduce((sl1, sl2) => sl1 + sl2);
    return screenLines * lineHeight >= maxHeight;
  }
}
