import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../routes.dart';

class DiaryRecordCard extends StatelessWidget {
  final DiaryRecord record;

  const DiaryRecordCard({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.form,
          arguments: record,
        ),
        onLongPress: () async {
          if (await _showConfirmDialog(context) ?? false) {
            context.read(diaryRecordControllerProvider).delete(record);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    record.created.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: record.favourite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onTap: () => context
                        .read(diaryRecordControllerProvider)
                        .toggleFavourite(record),
                  ),
                ],
              ),
              Text(record.text),
            ],
          ),
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
