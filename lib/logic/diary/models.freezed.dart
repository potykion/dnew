// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DiaryRecord _$DiaryRecordFromJson(Map<String, dynamic> json) {
  return _DiaryRecord.fromJson(json);
}

/// @nodoc
class _$DiaryRecordTearOff {
  const _$DiaryRecordTearOff();

  _DiaryRecord call(
      {String? id,
      required DateTime created,
      required String text,
      required String userId,
      bool favourite = false,
      List<String> tags = const <String>[]}) {
    return _DiaryRecord(
      id: id,
      created: created,
      text: text,
      userId: userId,
      favourite: favourite,
      tags: tags,
    );
  }

  DiaryRecord fromJson(Map<String, Object> json) {
    return DiaryRecord.fromJson(json);
  }
}

/// @nodoc
const $DiaryRecord = _$DiaryRecordTearOff();

/// @nodoc
mixin _$DiaryRecord {
  String? get id => throw _privateConstructorUsedError;
  DateTime get created => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  bool get favourite => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiaryRecordCopyWith<DiaryRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryRecordCopyWith<$Res> {
  factory $DiaryRecordCopyWith(
          DiaryRecord value, $Res Function(DiaryRecord) then) =
      _$DiaryRecordCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      DateTime created,
      String text,
      String userId,
      bool favourite,
      List<String> tags});
}

/// @nodoc
class _$DiaryRecordCopyWithImpl<$Res> implements $DiaryRecordCopyWith<$Res> {
  _$DiaryRecordCopyWithImpl(this._value, this._then);

  final DiaryRecord _value;
  // ignore: unused_field
  final $Res Function(DiaryRecord) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? created = freezed,
    Object? text = freezed,
    Object? userId = freezed,
    Object? favourite = freezed,
    Object? tags = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      created: created == freezed
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      favourite: favourite == freezed
          ? _value.favourite
          : favourite // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$DiaryRecordCopyWith<$Res>
    implements $DiaryRecordCopyWith<$Res> {
  factory _$DiaryRecordCopyWith(
          _DiaryRecord value, $Res Function(_DiaryRecord) then) =
      __$DiaryRecordCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      DateTime created,
      String text,
      String userId,
      bool favourite,
      List<String> tags});
}

/// @nodoc
class __$DiaryRecordCopyWithImpl<$Res> extends _$DiaryRecordCopyWithImpl<$Res>
    implements _$DiaryRecordCopyWith<$Res> {
  __$DiaryRecordCopyWithImpl(
      _DiaryRecord _value, $Res Function(_DiaryRecord) _then)
      : super(_value, (v) => _then(v as _DiaryRecord));

  @override
  _DiaryRecord get _value => super._value as _DiaryRecord;

  @override
  $Res call({
    Object? id = freezed,
    Object? created = freezed,
    Object? text = freezed,
    Object? userId = freezed,
    Object? favourite = freezed,
    Object? tags = freezed,
  }) {
    return _then(_DiaryRecord(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      created: created == freezed
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      favourite: favourite == freezed
          ? _value.favourite
          : favourite // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_DiaryRecord extends _DiaryRecord {
  const _$_DiaryRecord(
      {this.id,
      required this.created,
      required this.text,
      required this.userId,
      this.favourite = false,
      this.tags = const <String>[]})
      : super._();

  factory _$_DiaryRecord.fromJson(Map<String, dynamic> json) =>
      _$_$_DiaryRecordFromJson(json);

  @override
  final String? id;
  @override
  final DateTime created;
  @override
  final String text;
  @override
  final String userId;
  @JsonKey(defaultValue: false)
  @override
  final bool favourite;
  @JsonKey(defaultValue: const <String>[])
  @override
  final List<String> tags;

  @override
  String toString() {
    return 'DiaryRecord(id: $id, created: $created, text: $text, userId: $userId, favourite: $favourite, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DiaryRecord &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.created, created) ||
                const DeepCollectionEquality()
                    .equals(other.created, created)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.favourite, favourite) ||
                const DeepCollectionEquality()
                    .equals(other.favourite, favourite)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(created) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(favourite) ^
      const DeepCollectionEquality().hash(tags);

  @JsonKey(ignore: true)
  @override
  _$DiaryRecordCopyWith<_DiaryRecord> get copyWith =>
      __$DiaryRecordCopyWithImpl<_DiaryRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DiaryRecordToJson(this);
  }
}

abstract class _DiaryRecord extends DiaryRecord {
  const factory _DiaryRecord(
      {String? id,
      required DateTime created,
      required String text,
      required String userId,
      bool favourite,
      List<String> tags}) = _$_DiaryRecord;
  const _DiaryRecord._() : super._();

  factory _DiaryRecord.fromJson(Map<String, dynamic> json) =
      _$_DiaryRecord.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  DateTime get created => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  String get userId => throw _privateConstructorUsedError;
  @override
  bool get favourite => throw _privateConstructorUsedError;
  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DiaryRecordCopyWith<_DiaryRecord> get copyWith =>
      throw _privateConstructorUsedError;
}
