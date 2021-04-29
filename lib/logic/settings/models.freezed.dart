// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
class _$AppSettingsTearOff {
  const _$AppSettingsTearOff();

  _AppSettings call(
      {required bool isDarkMode,
      required bool deleteBlank,
      required bool autoSave,
      required DiaryRecordDisplayMode displayMode}) {
    return _AppSettings(
      isDarkMode: isDarkMode,
      deleteBlank: deleteBlank,
      autoSave: autoSave,
      displayMode: displayMode,
    );
  }

  AppSettings fromJson(Map<String, Object> json) {
    return AppSettings.fromJson(json);
  }
}

/// @nodoc
const $AppSettings = _$AppSettingsTearOff();

/// @nodoc
mixin _$AppSettings {
  bool get isDarkMode => throw _privateConstructorUsedError;
  bool get deleteBlank => throw _privateConstructorUsedError;
  bool get autoSave => throw _privateConstructorUsedError;
  DiaryRecordDisplayMode get displayMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res>;
  $Res call(
      {bool isDarkMode,
      bool deleteBlank,
      bool autoSave,
      DiaryRecordDisplayMode displayMode});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res> implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  final AppSettings _value;
  // ignore: unused_field
  final $Res Function(AppSettings) _then;

  @override
  $Res call({
    Object? isDarkMode = freezed,
    Object? deleteBlank = freezed,
    Object? autoSave = freezed,
    Object? displayMode = freezed,
  }) {
    return _then(_value.copyWith(
      isDarkMode: isDarkMode == freezed
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteBlank: deleteBlank == freezed
          ? _value.deleteBlank
          : deleteBlank // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSave: autoSave == freezed
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      displayMode: displayMode == freezed
          ? _value.displayMode
          : displayMode // ignore: cast_nullable_to_non_nullable
              as DiaryRecordDisplayMode,
    ));
  }
}

/// @nodoc
abstract class _$AppSettingsCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(
          _AppSettings value, $Res Function(_AppSettings) then) =
      __$AppSettingsCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isDarkMode,
      bool deleteBlank,
      bool autoSave,
      DiaryRecordDisplayMode displayMode});
}

/// @nodoc
class __$AppSettingsCopyWithImpl<$Res> extends _$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(
      _AppSettings _value, $Res Function(_AppSettings) _then)
      : super(_value, (v) => _then(v as _AppSettings));

  @override
  _AppSettings get _value => super._value as _AppSettings;

  @override
  $Res call({
    Object? isDarkMode = freezed,
    Object? deleteBlank = freezed,
    Object? autoSave = freezed,
    Object? displayMode = freezed,
  }) {
    return _then(_AppSettings(
      isDarkMode: isDarkMode == freezed
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteBlank: deleteBlank == freezed
          ? _value.deleteBlank
          : deleteBlank // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSave: autoSave == freezed
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      displayMode: displayMode == freezed
          ? _value.displayMode
          : displayMode // ignore: cast_nullable_to_non_nullable
              as DiaryRecordDisplayMode,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_AppSettings extends _AppSettings {
  const _$_AppSettings(
      {required this.isDarkMode,
      required this.deleteBlank,
      required this.autoSave,
      required this.displayMode})
      : super._();

  factory _$_AppSettings.fromJson(Map<String, dynamic> json) =>
      _$_$_AppSettingsFromJson(json);

  @override
  final bool isDarkMode;
  @override
  final bool deleteBlank;
  @override
  final bool autoSave;
  @override
  final DiaryRecordDisplayMode displayMode;

  @override
  String toString() {
    return 'AppSettings(isDarkMode: $isDarkMode, deleteBlank: $deleteBlank, autoSave: $autoSave, displayMode: $displayMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AppSettings &&
            (identical(other.isDarkMode, isDarkMode) ||
                const DeepCollectionEquality()
                    .equals(other.isDarkMode, isDarkMode)) &&
            (identical(other.deleteBlank, deleteBlank) ||
                const DeepCollectionEquality()
                    .equals(other.deleteBlank, deleteBlank)) &&
            (identical(other.autoSave, autoSave) ||
                const DeepCollectionEquality()
                    .equals(other.autoSave, autoSave)) &&
            (identical(other.displayMode, displayMode) ||
                const DeepCollectionEquality()
                    .equals(other.displayMode, displayMode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isDarkMode) ^
      const DeepCollectionEquality().hash(deleteBlank) ^
      const DeepCollectionEquality().hash(autoSave) ^
      const DeepCollectionEquality().hash(displayMode);

  @JsonKey(ignore: true)
  @override
  _$AppSettingsCopyWith<_AppSettings> get copyWith =>
      __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AppSettingsToJson(this);
  }
}

abstract class _AppSettings extends AppSettings {
  const factory _AppSettings(
      {required bool isDarkMode,
      required bool deleteBlank,
      required bool autoSave,
      required DiaryRecordDisplayMode displayMode}) = _$_AppSettings;
  const _AppSettings._() : super._();

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$_AppSettings.fromJson;

  @override
  bool get isDarkMode => throw _privateConstructorUsedError;
  @override
  bool get deleteBlank => throw _privateConstructorUsedError;
  @override
  bool get autoSave => throw _privateConstructorUsedError;
  @override
  DiaryRecordDisplayMode get displayMode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AppSettingsCopyWith<_AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
