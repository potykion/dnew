import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'md_actions.dart';

class MarkdownEditor extends HookWidget {
  final String initial;
  final Function(String text) change;
  final Function(bool focused) focusChange;

  MarkdownEditor({
    required this.initial,
    required this.change,
    required this.focusChange,
  });

  OverlayEntry? keyboardActionsOverlay;

  @override
  Widget build(BuildContext context) {
    var textTec = useTextEditingController(text: initial);

    void hideKeyboardActionsOverlay() {
      keyboardActionsOverlay?.remove();
    }

    void showKeyboardActionsOverlay({
      bool remove = false,
      bool isSelectionActions = false,
    }) {
      if (remove) {
        hideKeyboardActionsOverlay();
      }

      keyboardActionsOverlay = OverlayEntry(
        builder: (context) => Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: KeyboardMarkdownActions(
            initialText: textTec.text,
            initialSelection: textTec.selection,
            isSelectionActions: isSelectionActions,
            onAction: (text, selection) {
              textTec.text = text;
              textTec.selection = selection;
            },
          ),
        ),
      );

      Overlay.of(context)!.insert(keyboardActionsOverlay!);
    }

    var focus = useFocusNode();
    // При потере фокуса - скрываем экшены
    focus.addListener(() {
      if (focus.hasFocus) {
        showKeyboardActionsOverlay();
      } else {
        hideKeyboardActionsOverlay();
      }

      focusChange(focus.hasFocus);
    });

    // Если прожали перевод строки и пред строка - элемент списка (- / - [ ] / - [x])
    // То прописываем новый элемент списка
    useValueChanged<String, void>(textTec.text, (old, __) {
      var newlineEntered =
          "\n".allMatches(textTec.text).length > "\n".allMatches(old).length;
      if (newlineEntered) {
        var newTextAndSelection =
            tryContinueMarkdownList(textTec.text, textTec.selection);
        if (newTextAndSelection != null) {
          textTec.text = newTextAndSelection.item1;
          textTec.selection = newTextAndSelection.item2;
        }
      }
    });

    // Если выделили текст, то показываем экшены для выделенного теста
    textTec.addListener(() {
      if (textTec.selection.baseOffset == -1) return;
      var textSelected =
          textTec.selection.baseOffset != textTec.selection.extentOffset;
      if (textSelected) {
        showKeyboardActionsOverlay(
          remove: true,
          isSelectionActions: textSelected,
        );
      }
    });

    // var keyboardVisibilityController = KeyboardVisibilityController();
    // keyboardVisibilityController.onChange.listen((visible) {
    //   if (!visible) {
    //     try {
    //       showSelectionActionsState.value = null;
    //     } on FlutterError {
    //       /// При уходе со страницы, клавиатура мб убрана =>
    //       /// отработает обработчик, а страница уже задиспоузена =>
    //       /// тупа ловим это
    //     }
    //   }
    // });

    return TextFormField(
      onChanged: change,
      focusNode: focus,
      controller: textTec,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Что произошло?",
      ),
    );
  }
}
