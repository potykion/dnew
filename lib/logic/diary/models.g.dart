// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DiaryRecord _$_$_DiaryRecordFromJson(Map json) {
  return _$_DiaryRecord(
    id: json['id'] as String?,
    created: DateTime.parse(json['created'] as String),
    text: json['text'] as String,
    userId: json['userId'] as String,
    favourite: json['favourite'] as bool? ?? false,
  );
}

Map<String, dynamic> _$_$_DiaryRecordToJson(_$_DiaryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created.toIso8601String(),
      'text': instance.text,
      'userId': instance.userId,
      'favourite': instance.favourite,
    };
