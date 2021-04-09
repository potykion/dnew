import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/widgets/tags.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    var textTec = useTextEditingController(text: record.value.text);
    textTec.addListener(() {
      record.value = record.value.copyWith(text: textTec.text.trim());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          record.value.id != null ? "Редактирование записи" : "Создание записи",
        ),
      ),
      body: Padding(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          if (record.value.id != null) {
            await context
                .read(diaryRecordControllerProvider.notifier)
                .update(record.value);
          } else {
            await context
                .read(diaryRecordControllerProvider.notifier)
                .create(record.value);
          }

          Navigator.pop(context);
        },
      ),
    );
  }
}
