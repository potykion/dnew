import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
class SearchQuery with _$SearchQuery {
  const factory SearchQuery.text([@Default("") String text]) = TextSearchQuery;

  const factory SearchQuery.tag(String tag) = TagSearchQuery;

  const factory SearchQuery.favourite() = FavouriteSearchQuery;
}
