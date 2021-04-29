// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppSettings _$_$_AppSettingsFromJson(Map json) {
  return _$_AppSettings(
    isDarkMode: json['isDarkMode'] as bool,
    deleteBlank: json['deleteBlank'] as bool,
    autoSave: json['autoSave'] as bool,
    displayMode:
        _$enumDecode(_$DiaryRecordDisplayModeEnumMap, json['displayMode']),
  );
}

Map<String, dynamic> _$_$_AppSettingsToJson(_$_AppSettings instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'deleteBlank': instance.deleteBlank,
      'autoSave': instance.autoSave,
      'displayMode': _$DiaryRecordDisplayModeEnumMap[instance.displayMode],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$DiaryRecordDisplayModeEnumMap = {
  DiaryRecordDisplayMode.list: 'list',
  DiaryRecordDisplayMode.day: 'day',
  DiaryRecordDisplayMode.week: 'week',
};
