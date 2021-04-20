import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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

  var keyboardVisibilityController = KeyboardVisibilityController();

  @override
  Widget build(BuildContext context) {
    var textTec = useTextEditingController(text: initial);
    useValueChanged<String, void>(initial, (_, __) {
      if (textTec.text != initial) textTec.text = initial;
    });

    var keyboardActionsOpened = useState(false);
    void hideKeyboardActionsOverlay() {
      if (!keyboardActionsOpened.value) return;
      keyboardActionsOverlay?.remove();
      keyboardActionsOpened.value = false;
    }

    useEffect(() => hideKeyboardActionsOverlay, []);

    void showKeyboardActionsOverlay() {
      print("showKeyboardActionsOverlay");
      print("keyboardActionsOpened = $keyboardActionsOpened");
      if (keyboardActionsOpened.value) return;
      keyboardActionsOverlay = OverlayEntry(
        builder: (context) => Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: KeyboardMarkdownActions(
            controller: textTec,
          ),
        ),
      );
      Overlay.of(context)!.insert(keyboardActionsOverlay!);
      keyboardActionsOpened.value = true;
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

    // keyboardVisibilityController.onChange.listen((bool visible) {
    //   if (!visible) {
    //     hideKeyboardActionsOverlay();
    //   }
    // });

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
