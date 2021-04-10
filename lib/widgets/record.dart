import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/diary/search/models.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes.dart';

class DiaryRecordCard extends HookWidget {
  final DiaryRecord record;
  final bool showDate;

  const DiaryRecordCard({
    Key? key,
    required this.record,
    this.showDate = true,
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
            context.read(diaryRecordControllerProvider.notifier).delete(record);
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
                    (showDate ? DateFormat.yMd().add_Hms() : DateFormat.Hms())
                        .format(record.created),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: record.favourite
                        ? Icon(
                            Icons.favorite,
                            color: Theme.of(context).accentColor,
                          )
                        : Icon(Icons.favorite_border),
                    onTap: () => context
                        .read(diaryRecordControllerProvider.notifier)
                        .toggleFavourite(record),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: record.text,
                    onTapLink: (_, href, __) async {
                      if (href != null) {
                        await launch(href);
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      a: Theme.of(context).textTheme.button,
                    ),
                  ),
                  if (record.tags.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "\n"),
                          for (var tag in record.tags) ...[
                            TextSpan(
                              text: tag,
                              style: Theme.of(context).textTheme.button,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(
                                      context,
                                      Routes.list,
                                      arguments: SearchQuery.tag(tag),
                                    ),
                            ),
                            TextSpan(text: " "),
                          ]
                        ],
                      ),
                    )
                ],
              ),
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

class DiaryRecordsCollapse extends HookWidget {
  final String label;
  final List<DiaryRecord> dateRecords;
  final bool opened;
  final bool showDate;
  final Function(bool) onOpenedChange;

  const DiaryRecordsCollapse({
    Key? key,
    required this.label,
    required this.dateRecords,
    required this.opened,
    this.showDate = true,
    required this.onOpenedChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          title: Text(label),
          trailing: Icon(
              opened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          onTap: () => onOpenedChange(!opened),
        ),
        if (opened)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  120 - // AppBar height
                  50 - // ListTile height
                  50 - // ListTile height
                  60 // BottomNav height
              ,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                shrinkWrap: true,
                children: dateRecords
                    .map(
                      (r) => DiaryRecordCard(
                        record: r,
                        showDate: showDate,
                      ),
                    )
                    .toList(),
              ),
            ),
          )
      ],
    );
  }
}
