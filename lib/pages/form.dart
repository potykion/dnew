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
  @override
  Widget build(BuildContext context) {
    var showPreview = useState(false);

    var mdActionsSelectionState = useState(TextSelection(baseOffset: 0, extentOffset: 0));
    // null - не показываем экшены
    // true - показываем экшены для выделенного текста
    // false - показываем экшены для текста (списки, хедеры)
    var showSelectionActionsState = useState<bool?>(null);

    var record = useState(
      ModalRoute.of(context)!.settings.arguments as DiaryRecord? ??
          DiaryRecord.blank(userId: FirebaseAuth.instance.currentUser!.uid),
    );

    var focus = useFocusNode();
    focus.addListener(() {
      showSelectionActionsState.value = focus.hasFocus ? false : null;
    });

    var textTec = useTextEditingController(text: record.value.text);
    textTec.addListener(() {
      record.value = record.value.copyWith(text: textTec.text);
    });
    textTec.addListener(() {
      mdActionsSelectionState.value =textTec.selection;
      var textSelected =
          textTec.selection.baseOffset != textTec.selection.extentOffset;
      showSelectionActionsState.value = textSelected ? true : false;
    });

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        showSelectionActionsState.value = null;
      }
    });

    save() async {
      if (record.value.id != null) {
        await context
            .read(diaryRecordControllerProvider.notifier)
            .update(record.value.copyWith(text: record.value.text.trim()));
      } else {
        await context
            .read(diaryRecordControllerProvider.notifier)
            .create(record.value.copyWith(text: record.value.text.trim()));
      }

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: save,
            icon: Icon(Icons.done),
          ),
          IconButton(
            onPressed: () => showPreview.value = !showPreview.value,
            icon: Icon(showPreview.value ? Icons.edit : Icons.remove_red_eye),
          )
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
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
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
                          change: (tags) =>
                              record.value = record.value.copyWith(tags: tags),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showSelectionActionsState.value != null)
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 0,
                    child: KeyboardMarkdownActions(
                      initialText: textTec.text,
                      initialSelection: mdActionsSelectionState.value,
                      isSelectionActions: showSelectionActionsState.value!,
                      onAction: (text, selection) {
                        textTec.text = text;
                        textTec.selection = selection;
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
