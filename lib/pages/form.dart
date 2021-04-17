import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/widgets/md_actions.dart';
import 'package:dnew/widgets/record.dart';
import 'package:dnew/widgets/tags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DiaryRecordFormPage extends HookWidget {

  OverlayEntry? keyboardActionsOverlay;

  @override
  Widget build(BuildContext context) {
    var record = useState(
      ModalRoute.of(context)!.settings.arguments as DiaryRecord? ??
          DiaryRecord.blank(userId: FirebaseAuth.instance.currentUser!.uid),
    );

    var showPreview = useState(false);

    // null - не показываем экшены
    // true - показываем экшены для выделенного текста
    // false - показываем экшены для текста (списки, хедеры)
    var showSelectionActionsState = useState<bool?>(null);

    var focus = useFocusNode();
    // При потере фокуса - скрываем экшены
    focus.addListener(() {
      showSelectionActionsState.value = focus.hasFocus ? false : null;
    });

    var textTec = useTextEditingController(text: record.value.text);
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
      var textSelected =
          textTec.selection.baseOffset != textTec.selection.extentOffset;
      showSelectionActionsState.value = textSelected ? true : false;
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        try {
          showSelectionActionsState.value = null;
        } on FlutterError {
          /// При уходе со страницы, клавиатура мб убрана =>
          /// отработает обработчик, а страница уже задиспоузена =>
          /// тупа ловим это
        }
      }
    });


    useValueChanged<bool?, void>(showSelectionActionsState.value, (_, __) {
      print(showSelectionActionsState.value);
      if (showSelectionActionsState.value == null) {
        keyboardActionsOverlay?.remove();
        return;
      }

      keyboardActionsOverlay = OverlayEntry(
        builder: (context) => Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: KeyboardMarkdownActions(
            initialText: textTec.text,
            initialSelection: textTec.selection,
            isSelectionActions: showSelectionActionsState.value ?? false,
            onAction: (text, selection) {
              textTec.text = text;
              textTec.selection = selection;
            },
          ),
        ),
      );

      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        Overlay.of(context)!.insert(keyboardActionsOverlay!);
      });
    });

    var isSaving = useState(false);
    save() async {
      isSaving.value = true;

      if (record.value.id != null) {
        await context
            .read(diaryRecordControllerProvider.notifier)
            .update(record.value.copyWith(text: record.value.text.trim()));
      } else {
        record.value = record.value.copyWith(
          id: await context
              .read(diaryRecordControllerProvider.notifier)
              .create(record.value.copyWith(text: record.value.text.trim())),
        );
      }

      isSaving.value = false;
    }

    var saveTimer = useState<Timer?>(null);
    useEffect(
      () => () => saveTimer.value?.cancel(),
      [],
    );
    saveDebounce() {
      saveTimer.value?.cancel();
      saveTimer.value = Timer(Duration(milliseconds: 600), save);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isSaving.value)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  width: 20,
                  height: 20,
                ),
              ),
            )
          else
            IconButton(
              onPressed: () {
                saveTimer.value?.cancel();
                save();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.done),
            ),
          IconButton(
            onPressed: () => showPreview.value = !showPreview.value,
            icon: Icon(showPreview.value ? Icons.edit : Icons.remove_red_eye),
          ),
          if (record.value.id != null)
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  if (await _showConfirmDialog(context) ?? false) {
                    context
                        .read(diaryRecordControllerProvider.notifier)
                        .delete(record.value);
                    Navigator.pop(context);
                  }
                })
        ].reversed.toList(),
      ),
      body: showPreview.value
          ? Center(
              child: SingleChildScrollView(
                child: DiaryRecordCard(
                  record: record.value,
                  readonly: true,
                ),
              ),
            )
          : Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMd()
                        .add_Hms()
                        .format(record.value.created),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Expanded(
                  child: TextFormField(
                    onChanged: (_) {
                      if (textTec.text == record.value.text) return;
                      record.value =
                          record.value.copyWith(text: textTec.text);

                      saveDebounce();
                    },
                    focusNode: focus,
                    controller: textTec,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Что произошло?",
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: showSelectionActionsState.value != null
                        ? 30 // = высота KeyboardMarkdownActions
                        : 0,
                  ),
                  child: TagsInput(
                    initial: record.value.tags,
                    change: (tags) {
                      if (ListEquality<String>()
                          .equals(tags, record.value.tags)) return;

                      record.value = record.value.copyWith(tags: tags);

                      saveDebounce();
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Удаление записи"),
          content: Text("Вы хотите удалить запись?"),
          actions: [
            TextButton(
              child: Text("Нет"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text("Да"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
}
