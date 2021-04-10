import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/widgets/actions.dart';
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
    var showSelectionActionsState = useState(false);

    var record = useState(
      ModalRoute.of(context)!.settings.arguments as DiaryRecord? ??
          DiaryRecord.blank(userId: FirebaseAuth.instance.currentUser!.uid),
    );

    var textTec = useTextEditingController(text: record.value.text);
    textTec.addListener(() {
      record.value = record.value.copyWith(text: textTec.text);
    });
    textTec.addListener(() {
      var textSelected =
          textTec.selection.baseOffset != textTec.selection.extentOffset;
      showSelectionActionsState.value = textSelected;
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
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMd().add_Hms().format(record.value.created),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Expanded(
                  child: TextFormField(
                    // focusNode: focusState.value,
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
                TagsInput(
                  initial: record.value.tags,
                  change: (tags) =>
                      record.value = record.value.copyWith(tags: tags),
                ),
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: KeyboardActions(
              initialText: textTec.text,
              initialSelection: textTec.selection,
              isSelectionActions: showSelectionActionsState.value,
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
