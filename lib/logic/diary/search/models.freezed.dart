// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SearchQueryTearOff {
  const _$SearchQueryTearOff();

  TextSearchQuery text([String text = ""]) {
    return TextSearchQuery(
      text,
    );
  }

  TagSearchQuery tag(String tag) {
    return TagSearchQuery(
      tag,
    );
  }

  FavouriteSearchQuery favourite() {
    return const FavouriteSearchQuery();
  }
}

/// @nodoc
const $SearchQuery = _$SearchQueryTearOff();

/// @nodoc
mixin _$SearchQuery {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) text,
    required TResult Function(String tag) tag,
    required TResult Function() favourite,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? text,
    TResult Function(String tag)? tag,
    TResult Function()? favourite,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextSearchQuery value) text,
    required TResult Function(TagSearchQuery value) tag,
    required TResult Function(FavouriteSearchQuery value) favourite,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextSearchQuery value)? text,
    TResult Function(TagSearchQuery value)? tag,
    TResult Function(FavouriteSearchQuery value)? favourite,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchQueryCopyWith<$Res> {
  factory $SearchQueryCopyWith(
          SearchQuery value, $Res Function(SearchQuery) then) =
      _$SearchQueryCopyWithImpl<$Res>;
}

/// @nodoc
class _$SearchQueryCopyWithImpl<$Res> implements $SearchQueryCopyWith<$Res> {
  _$SearchQueryCopyWithImpl(this._value, this._then);

  final SearchQuery _value;
  // ignore: unused_field
  final $Res Function(SearchQuery) _then;
}

/// @nodoc
abstract class $TextSearchQueryCopyWith<$Res> {
  factory $TextSearchQueryCopyWith(
          TextSearchQuery value, $Res Function(TextSearchQuery) then) =
      _$TextSearchQueryCopyWithImpl<$Res>;
  $Res call({String text});
}

/// @nodoc
class _$TextSearchQueryCopyWithImpl<$Res>
    extends _$SearchQueryCopyWithImpl<$Res>
    implements $TextSearchQueryCopyWith<$Res> {
  _$TextSearchQueryCopyWithImpl(
      TextSearchQuery _value, $Res Function(TextSearchQuery) _then)
      : super(_value, (v) => _then(v as TextSearchQuery));

  @override
  TextSearchQuery get _value => super._value as TextSearchQuery;

  @override
  $Res call({
    Object? text = freezed,
  }) {
    return _then(TextSearchQuery(
      text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$TextSearchQuery implements TextSearchQuery {
  const _$TextSearchQuery([this.text = ""]);

  @JsonKey(defaultValue: "")
  @override
  final String text;

  @override
  String toString() {
    return 'SearchQuery.text(text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is TextSearchQuery &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(text);

  @JsonKey(ignore: true)
  @override
  $TextSearchQueryCopyWith<TextSearchQuery> get copyWith =>
      _$TextSearchQueryCopyWithImpl<TextSearchQuery>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) text,
    required TResult Function(String tag) tag,
    required TResult Function() favourite,
  }) {
    return text(this.text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? text,
    TResult Function(String tag)? tag,
    TResult Function()? favourite,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this.text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextSearchQuery value) text,
    required TResult Function(TagSearchQuery value) tag,
    required TResult Function(FavouriteSearchQuery value) favourite,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextSearchQuery value)? text,
    TResult Function(TagSearchQuery value)? tag,
    TResult Function(FavouriteSearchQuery value)? favourite,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class TextSearchQuery implements SearchQuery {
  const factory TextSearchQuery([String text]) = _$TextSearchQuery;

  String get text => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TextSearchQueryCopyWith<TextSearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagSearchQueryCopyWith<$Res> {
  factory $TagSearchQueryCopyWith(
          TagSearchQuery value, $Res Function(TagSearchQuery) then) =
      _$TagSearchQueryCopyWithImpl<$Res>;
  $Res call({String tag});
}

/// @nodoc
class _$TagSearchQueryCopyWithImpl<$Res> extends _$SearchQueryCopyWithImpl<$Res>
    implements $TagSearchQueryCopyWith<$Res> {
  _$TagSearchQueryCopyWithImpl(
      TagSearchQuery _value, $Res Function(TagSearchQuery) _then)
      : super(_value, (v) => _then(v as TagSearchQuery));

  @override
  TagSearchQuery get _value => super._value as TagSearchQuery;

  @override
  $Res call({
    Object? tag = freezed,
  }) {
    return _then(TagSearchQuery(
      tag == freezed
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$TagSearchQuery implements TagSearchQuery {
  const _$TagSearchQuery(this.tag);

  @override
  final String tag;

  @override
  String toString() {
    return 'SearchQuery.tag(tag: $tag)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is TagSearchQuery &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(tag);

  @JsonKey(ignore: true)
  @override
  $TagSearchQueryCopyWith<TagSearchQuery> get copyWith =>
      _$TagSearchQueryCopyWithImpl<TagSearchQuery>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) text,
    required TResult Function(String tag) tag,
    required TResult Function() favourite,
  }) {
    return tag(this.tag);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? text,
    TResult Function(String tag)? tag,
    TResult Function()? favourite,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(this.tag);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextSearchQuery value) text,
    required TResult Function(TagSearchQuery value) tag,
    required TResult Function(FavouriteSearchQuery value) favourite,
  }) {
    return tag(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextSearchQuery value)? text,
    TResult Function(TagSearchQuery value)? tag,
    TResult Function(FavouriteSearchQuery value)? favourite,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(this);
    }
    return orElse();
  }
}

abstract class TagSearchQuery implements SearchQuery {
  const factory TagSearchQuery(String tag) = _$TagSearchQuery;

  String get tag => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagSearchQueryCopyWith<TagSearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavouriteSearchQueryCopyWith<$Res> {
  factory $FavouriteSearchQueryCopyWith(FavouriteSearchQuery value,
          $Res Function(FavouriteSearchQuery) then) =
      _$FavouriteSearchQueryCopyWithImpl<$Res>;
}

/// @nodoc
class _$FavouriteSearchQueryCopyWithImpl<$Res>
    extends _$SearchQueryCopyWithImpl<$Res>
    implements $FavouriteSearchQueryCopyWith<$Res> {
  _$FavouriteSearchQueryCopyWithImpl(
      FavouriteSearchQuery _value, $Res Function(FavouriteSearchQuery) _then)
      : super(_value, (v) => _then(v as FavouriteSearchQuery));

  @override
  FavouriteSearchQuery get _value => super._value as FavouriteSearchQuery;
}

/// @nodoc
class _$FavouriteSearchQuery implements FavouriteSearchQuery {
  const _$FavouriteSearchQuery();

  @override
  String toString() {
    return 'SearchQuery.favourite()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is FavouriteSearchQuery);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) text,
    required TResult Function(String tag) tag,
    required TResult Function() favourite,
  }) {
    return favourite();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? text,
    TResult Function(String tag)? tag,
    TResult Function()? favourite,
    required TResult orElse(),
  }) {
    if (favourite != null) {
      return favourite();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextSearchQuery value) text,
    required TResult Function(TagSearchQuery value) tag,
    required TResult Function(FavouriteSearchQuery value) favourite,
  }) {
    return favourite(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextSearchQuery value)? text,
    TResult Function(TagSearchQuery value)? tag,
    TResult Function(FavouriteSearchQuery value)? favourite,
    required TResult orElse(),
  }) {
    if (favourite != null) {
      return favourite(this);
    }
    return orElse();
  }
}

abstract class FavouriteSearchQuery implements SearchQuery {
  const factory FavouriteSearchQuery() = _$FavouriteSearchQuery;
}
