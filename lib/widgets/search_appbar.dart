import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/diary/search/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../routes.dart';

class SearchAppBar extends HookWidget {
  final SearchQuery searchQuery;

  const SearchAppBar({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverAppBar(
        floating: true,
        toolbarHeight: kToolbarHeight + 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        title: SearchInput(searchQuery),
      );
}

class SearchInput extends HookWidget {
  final SearchQuery searchQuery;

  SearchInput(this.searchQuery);

  @override
  Widget build(BuildContext context) {
    var showCleanButtonState = useState(false);

    var tec = useTextEditingController(
      text: searchQuery.when(
        text: (text) => text,
        tag: (tag) => tag,
        favourite: () => "Избранное",
      ),
    );
    tec.addListener(() {
      showCleanButtonState.value = tec.text.isNotEmpty;
    });

    var tags = useProvider(tagsProvider);

    return TypeAheadFormField<SearchQuery>(
      textFieldConfiguration: TextFieldConfiguration(
        onSubmitted: (_) {
          if (tec.text.isNotEmpty) {
            Navigator.pushNamed(
              context,
              Routes.list,
              arguments: SearchQuery.text(tec.text),
            );
          }
        },
        enabled: searchQuery is TextSearchQuery &&
            (searchQuery as TextSearchQuery).text.isEmpty,
        controller: tec,
        decoration: InputDecoration(
          hintText: "Поищем что-нибудь?",
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (searchQuery is TextSearchQuery) ...[
                  if (showCleanButtonState.value) ...[
                    GestureDetector(
                      child: Icon(Icons.close),
                      onTap: () {
                        tec.text = "";
                      },
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                  ],
                  GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: searchQuery is TextSearchQuery &&
                              (searchQuery as TextSearchQuery).text.isEmpty
                          ? null
                          : Theme.of(context).accentColor,
                    ),
                    onTap: () {
                      if (tec.text.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          Routes.list,
                          arguments: SearchQuery.text(tec.text),
                        );
                      }
                    },
                  )
                ],
                if (searchQuery is FavouriteSearchQuery)
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).accentColor,
                  ),
              ],
            ),
          ),
        ),
      ),
      hideSuggestionsOnKeyboardHide: true,
      hideOnEmpty: true,
      getImmediateSuggestions: true,
      suggestionsCallback: (String query) async {
        if (query == "") {
          return [
            for (var tag in tags.take(3)) SearchQuery.tag(tag),
            SearchQuery.favourite(),
          ];
        }

        if (query.startsWith("#")) {
          return context
              .read(searchTagsProvider(query))
              .map((t) => SearchQuery.tag(t));
        }

        return [];
      },
      itemBuilder: (context, query) {
        return query.when(
          text: (text) => ListTile(title: Text(text), dense: true),
          tag: (tag) => ListTile(title: Text(tag), dense: true),
          favourite: () => ListTile(
            title: Text("Избранное"),
            trailing: Icon(
              Icons.favorite,
              color: Theme.of(context).accentColor,
            ),
            dense: true,
          ),
        );
      },
      onSuggestionSelected: (query) {
        Navigator.pushNamed(context, Routes.list, arguments: query);
      },
    );
  }
}
