import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiaryRecordFormPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var record = useState(
      ModalRoute.of(context)!.settings.arguments as DiaryRecord? ??
          DiaryRecord.blank(),
    );
    var tec = useTextEditingController(text: record.value.text);
    tec.addListener(() {
      record.value = record.value.copyWith(text: tec.text);
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
                record.value.created.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: tec,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          if (record.value.id != null) {
            await context
                .read(diaryRecordControllerProvider)
                .update(record.value);
          } else {
            await context
                .read(diaryRecordControllerProvider)
                .create(record.value);
          }

          Navigator.pop(context);
        },
      ),
    );
  }
}
