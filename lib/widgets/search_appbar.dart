import 'package:dnew/logic/diary/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppBar extends HookWidget {
  final String title;

  const SearchAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tec = useTextEditingController(text: title);

    var showFavouriteState = useProvider(showFavouritesProvider);
    var showFavourites = showFavouriteState.state;
    void toggleShowFavourites() {
      showFavouriteState.state = !showFavouriteState.state;
    }

    return SliverAppBar(
      floating: true,
      toolbarHeight: kToolbarHeight + 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(
          bottom: Radius.circular(10)
        )
      ),
      // backgroundColor: Theme.of(context).canvasColor,
      title: TextFormField(
        controller: tec,
        decoration: InputDecoration(
            hintText: "Поищем что-нибудь?",
            filled: true,
            isDense: true,
            fillColor: Theme.of(context).canvasColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
      actions: [
        IconButton(
          icon: showFavourites
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          onPressed: toggleShowFavourites,
        )
      ],
    );
  }
}
