import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;

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
  final bool readonly;
  final void Function()? onEdit;
  final void Function()? onLike;

  DiaryRecordCard({
    Key? key,
    required this.record,
    this.showDate = true,
    this.readonly = false,
    this.onEdit,
    this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewFull = useState(false);

    return Card(
      child: InkWell(
        onTap: readonly
            ? null
            : () async {
                context.read(editableRecordProvider).state = record;
                await Navigator.pushNamed(context, Routes.form);
                if (onEdit != null) onEdit!();
              },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: record.text));
          final snackBar = SnackBar(content: Text('Запись скопирована.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDateAndFav(context),
              Divider(),
              if (viewFull.value)
                buildText(context, withSpace: true)
              else
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: buildText(context),
                ),
              if (record.isTextOverflow(MediaQuery.of(context).size.width))
                TextButton(
                  onPressed: () => viewFull.value = !viewFull.value,
                  child: Text(
                    viewFull.value ? "Свернуть" : "Развернуть",
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildDateAndFav(BuildContext context) {
    return Row(
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
          onTap: readonly
              ? null
              : () async {
                  await context
                      .read(diaryRecordControllerProvider.notifier)
                      .toggleFavourite(record);
                  if (onLike != null) onLike!();
                },
        ),
      ],
    );
  }

  Widget buildText(BuildContext context, {bool withSpace = false}) {
    return Wrap(
      clipBehavior: Clip.hardEdge,
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
            blockquoteDecoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ),
        if (record.tags.isNotEmpty)
          Row(
            children: [
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
              ),
            ],
          ),
        if (withSpace)
          SizedBox(
            width: double.infinity,
            height: 40,
          ),
      ],
    );
  }
}

class ParagraphWithNewlineBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return RichText(
      text: TextSpan(
        text: text.text,
        style: preferredStyle,
      ),
    );
  }
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
