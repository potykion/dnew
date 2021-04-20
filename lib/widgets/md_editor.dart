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
    useValueChanged<String, void>(initial, (_, __) {
      if (textTec.text != initial) textTec.text = initial;
    });

    void hideKeyboardActionsOverlay() {
      try {
        keyboardActionsOverlay?.remove();
      } on AssertionError {
        // Может быть такое, что оверлея уже нет => прост игнорим это
      }
    }

    useEffect(() => hideKeyboardActionsOverlay, []);

    void showKeyboardActionsOverlay({
      bool isSelectionActions = false,
    }) {
      hideKeyboardActionsOverlay();
      keyboardActionsOverlay = OverlayEntry(
        builder: (context) => Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: KeyboardMarkdownActions(
            controller: textTec,
            isSelectionActions: isSelectionActions,
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
      showKeyboardActionsOverlay(
        isSelectionActions: textSelected,
      );
    });

    textTec.addListener(() {
      change(textTec.text);
    });

    return TextFormField(
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
