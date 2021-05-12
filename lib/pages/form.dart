import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnew/logic/diary/models.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/logic/settings/controllers.dart';
import 'package:dnew/widgets/toolbar.dart';
import 'package:dnew/widgets/md_editor.dart';
import 'package:dnew/widgets/record.dart';
import 'package:dnew/widgets/tags.dart';
import 'package:dnew/widgets/web_padding.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DiaryRecordFormPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var settings = useProvider(appSettingsControllerProvider);

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

    saveDebounce() => EasyDebounce.debounce(
          'save',
          Duration(milliseconds: 600),
          () {
            if (settings.autoSave) {
              try {
                save();
              } on FlutterError {
                /// сейв может происходить когда нажали галочку =>
                /// то есть происходит диспоуз, а save обновляет стейт =>
                /// игнорим ошибку обновления стейта
              }
            }
          },
        );

    var textTec = useTextEditingController(text: record.state.text);
    // Выполняется когда импортнули маркдаун
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

    var isEdit = useState(true);
    var pageController = useMemoized(() => PageController());
    useEffect(() {
      var updateIsEdit = () => isEdit.value = pageController.page == 0;
      pageController.addListener(updateIsEdit);
      return () => pageController.removeListener(updateIsEdit);
    }, []);
    setEdit() {
      pageController.jumpToPage(0);
    }

    setPreview() {
      pageController.jumpToPage(1);
    }

    return WebPadding(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: setEdit,
                icon: Icon(
                  Icons.edit,
                  color: isEdit.value ? Theme.of(context).accentColor : null,
                ),
              ),
              IconButton(
                onPressed: setPreview,
                icon: Icon(
                  Icons.remove_red_eye,
                  color: !isEdit.value ? Theme.of(context).accentColor : null,
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
                onPressed: () async {
                  await save();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.done),
              ),
          ].reversed.toList(),
        ),
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ListView(
                        children: [
                          MarkdownEditor(
                            controller: textTec,
                            focusChange: (focused) {
                              textFocus.value = focused;
                            },
                            requestFocus: textTec.text.isEmpty,
                          ),
                          if (record.state.text.isNotEmpty)
                            TagsInput(
                              initial: record.state.tags,
                              change: (tags) {
                                if (ListEquality<String>()
                                    .equals(tags, record.state.tags)) return;

                                record.state =
                                    record.state.copyWith(tags: tags);

                                saveDebounce();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Toolbar(
                    textFocused: textFocus.value,
                    textTec: textTec,
                  ),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: DiaryRecordCard(
                  record: record.state,
                  readonly: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
