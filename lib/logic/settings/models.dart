import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

part 'models.g.dart';

enum DiaryRecordDisplayMode { list, day, week }

@freezed
class AppSettings with _$AppSettings {
  const AppSettings._();

  const factory AppSettings({
    required bool isDarkMode,
    required bool deleteBlank,
    required bool autoSave,
    required DiaryRecordDisplayMode displayMode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  factory AppSettings.blank() {
    return AppSettings(
      isDarkMode: true,
      deleteBlank: false,
      autoSave: false,
      displayMode: DiaryRecordDisplayMode.list,
    );
  }

  DiaryRecordDisplayMode getNextDisplayMode() {
    var nextIndex =
        (displayMode.index + 1) % DiaryRecordDisplayMode.values.length;
    return DiaryRecordDisplayMode.values[nextIndex];
  }
}
