import 'package:dnew/logic/diary/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppBar extends HookWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const SearchAppBar({
    Key? key,
    this.height = 80,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showFavouriteState = useProvider(showFavouritesProvider);
    var showFavourites = showFavouriteState.state;
    void toggleShowFavourites() {
      showFavouriteState.state = !showFavouriteState.state;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: ListTile(
              tileColor: Theme.of(context).primaryColor,
              title: Text(title),
              trailing: IconButton(
                icon: showFavourites
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: toggleShowFavourites,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
