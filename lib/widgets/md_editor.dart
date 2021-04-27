import 'package:dnew/logic/diary/controllers.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'md_toolbar.dart';

class MarkdownEditor extends HookWidget {
  final TextEditingController controller;

  final Function(bool focused)? focusChange;

  MarkdownEditor({
    required this.controller,
    this.focusChange,
  });

  @override
  Widget build(BuildContext context) {
    var focus = useFocusNode();
    focus.addListener(() {
      if (focusChange != null) focusChange!(focus.hasFocus);
    });

    // Если прожали перевод строки и пред строка - элемент списка (- / - [ ] / - [x])
    // То прописываем новый элемент списка
    useValueChanged<String, void>(controller.text, (old, __) {
      var newlineEntered =
          "\n".allMatches(controller.text).length > "\n".allMatches(old).length;
      if (newlineEntered) {
        var newTextAndSelection =
            tryContinueMarkdownList(controller.text, controller.selection);
        if (newTextAndSelection != null) {
          controller.text = newTextAndSelection.item1;
          controller.selection = newTextAndSelection.item2;
        }
      }
    });

    return TextFormField(
      focusNode: focus,
      controller: controller,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Что произошло?",
      ),
      onChanged: (text) {
        EasyDebounce.debounce(
          'history_append',
          Duration(milliseconds: 500),
          () => context.read(historyProvider).append(text),
        );
      },
    );
  }
}
