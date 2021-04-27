import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/widgets/toolbar.dart';
import 'package:dnew/widgets/md_editor.dart';
import 'package:dnew/widgets/record.dart';
import 'package:dnew/widgets/tags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DiaryRecordFormPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var record = useProvider(editableRecordProvider);
    useEffect(
      () {
        context.read(historyProvider).init(record.state.text);
      },
      [],
    );

    var isSaving = useState(false);
    save() async {
      isSaving.value = true;

      await context
          .read(diaryRecordControllerProvider.notifier)
          .update(record.state.copyWith(text: record.state.text.trim()));

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

    var textTec = useTextEditingController(text: record.state.text);
    useValueChanged<DiaryRecord, void>(record.state, (_, __) {
      if (textTec.text == record.state.text) return;
      textTec.text = record.state.text;
      saveDebounce();
    });
    textTec.addListener(() {
      if (textTec.text == record.state.text) return;
      record.state = record.state.copyWith(text: textTec.text);
      saveDebounce();
    });
    var textFocus = useState(false);

    var showPreview = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => showPreview.value = false,
              icon: Icon(
                Icons.edit,
                color:
                    !showPreview.value ? Theme.of(context).accentColor : null,
              ),
            ),
            IconButton(
              onPressed: () => showPreview.value = true,
              icon: Icon(
                Icons.remove_red_eye,
                color: showPreview.value ? Theme.of(context).accentColor : null,
              ),
            )
          ],
        ),
        centerTitle: true,
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
        ].reversed.toList(),
      ),
      body: showPreview.value
          ? Center(
              child: SingleChildScrollView(
                child: DiaryRecordCard(
                  record: record.state,
                  readonly: true,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMd().add_Hms().format(record.state.created),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: MarkdownEditor(
                      controller: textTec,
                      focusChange: (focused) {
                        textFocus.value = focused;
                      },
                    ),
                  ),
                  TagsInput(
                    initial: record.state.tags,
                    change: (tags) {
                      if (ListEquality<String>()
                          .equals(tags, record.state.tags)) return;

                      record.state = record.state.copyWith(tags: tags);

                      saveDebounce();
                    },
                  ),
                  Divider(),
                  Toolbar(
                    textFocused: textFocus.value,
                    textTec: textTec,
                  ),
                ],
              ),
            ),
    );
  }
}
