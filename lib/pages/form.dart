import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/widgets/md_editor.dart';
import 'package:dnew/widgets/record.dart';
import 'package:dnew/widgets/tags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DiaryRecordFormPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var record = useState(
      ModalRoute.of(context)!.settings.arguments as DiaryRecord? ??
          DiaryRecord.blank(userId: FirebaseAuth.instance.currentUser!.uid),
    );
    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        record.value = record.value.copyWith(
          id: await context
              .read(diaryRecordControllerProvider.notifier)
              .create(record.value.copyWith(text: record.value.text.trim())),
        );
      });
    });

    var showPreview = useState(false);

    var isSaving = useState(false);
    save() async {
      isSaving.value = true;

      await context
          .read(diaryRecordControllerProvider.notifier)
          .update(record.value.copyWith(text: record.value.text.trim()));

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

    var textFocus = useState(false);

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
                }),
          if (record.value.text == "")
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () async {
                var result = await FilePicker.platform.pickFiles(
                  allowedExtensions: ["md", "txt"],
                  type: FileType.custom,
                );
                if (result != null) {
                  var file = File(result.files.single.path!);
                  record.value =
                      record.value.copyWith(text: file.readAsStringSync());
                }
              },
            ),
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
              padding: EdgeInsets.all(12),
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
                    child: MarkdownEditor(
                      initial: record.value.text,
                      change: (text) {
                        if (text == record.value.text) return;
                        record.value = record.value.copyWith(text: text);
                        saveDebounce();
                      },
                      focusChange: (focused) {
                        textFocus.value = focused;
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: textFocus.value
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
