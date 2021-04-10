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

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SliverPadding(
        padding: EdgeInsets.only(
          top: 10 + MediaQuery.of(context).padding.top,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        sliver: SliverAppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: TextFormField(
            controller: tec,
            decoration: InputDecoration(
              hintText: "Поиск"
            ),
          ),
          actions: [
            IconButton(
              icon: showFavourites
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: toggleShowFavourites,
            )
          ],
          //
          // child: ClipRRect(
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          //   child: ListTile(
          //     tileColor: Theme.of(context).primaryColor,
          //     title: Text(title),
          //     trailing: ,
          //   ),
          // ),
        ),
      ),
    );
  }
}
