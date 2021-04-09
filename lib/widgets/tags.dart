import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/diary/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TagsInput extends HookWidget {
  final List<String> initial;
  final Function(List<String>) change;

  TagsInput({
    required this.initial,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    var tec = useTextEditingController(text: initial.join(" "));
    tec.addListener(() {
      change(parseTags(tec.text).toList());
    });

    return TypeAheadFormField<String>(
      direction: AxisDirection.up,
      textFieldConfiguration: TextFieldConfiguration(
        controller: tec,
        decoration: InputDecoration(hintText: "Теги, например #работа"),
      ),
      onSuggestionSelected: (tag) {
        var currentTags = parseTags(tec.text).toList();
        tec.text =
            [...currentTags.sublist(0, currentTags.length), tag].join(" ");
      },
      itemBuilder: (_, itemData) => ListTile(
        title: Text(itemData),
        dense: true,
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.endsWith(" ")) return [];

        String? lastTag;
        try {
          lastTag = parseTags(pattern, matchEmpty: true).last;
        } on StateError {}

        if (lastTag == null) return [];
        var tags = context.read(searchTagsProvider(lastTag));
        return tags;
      },
      hideSuggestionsOnKeyboardHide: true,
      hideOnEmpty: true,
    );
  }
}
