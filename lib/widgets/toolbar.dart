import 'dart:io';

import 'package:dnew/logic/diary/controllers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'md_toolbar.dart';

enum ToolbarState {
  initial,
  md,
}

class Toolbar extends HookWidget {
  final bool textFocused;
  final TextEditingController textTec;

  const Toolbar({
    Key? key,
    required this.textFocused,
    required this.textTec,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var toolbarState = useState(ToolbarState.initial);
    useValueChanged<bool, void>(textFocused, (_, __) {
      if (!textFocused) {
        toolbarState.value = ToolbarState.initial;
      }
    });

    var history = useProvider(historyProvider);

    Widget buildInitialToolbar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: textFocused ? 1 : 0,
            child: IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: textFocused
                  ? () => toolbarState.value = ToolbarState.md
                  : null,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.undo),
                onPressed: history.canUndo
                    ? () => context.read(editableRecordProvider).state = context
                        .read(editableRecordProvider)
                        .state
                        .copyWith(text: history.undo())
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.redo),
                onPressed: history.canRedo
                    ? () => context.read(editableRecordProvider).state = context
                        .read(editableRecordProvider)
                        .state
                        .copyWith(text: history.redo())
                    : null,
              ),
            ],
          ),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          _DeleteRecordTile(),
                          _ImportMarkdownTile(),
                        ],
                      );
                    });
              }),
        ],
      );
    }

    return Container(
      height: 30,
      child: toolbarState.value == ToolbarState.initial
          ? buildInitialToolbar()
          : MarkdownToolbar(
              controller: textTec,
              showBackBtn: true,
              onBack: () => toolbarState.value = ToolbarState.initial,
            ),
    );
  }
}

class _ImportMarkdownTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.file_download),
      title: Text("Импорт markdown"),
      onTap: () async {
        var result = await FilePicker.platform.pickFiles(
          allowedExtensions: ["md", "txt"],
          type: FileType.custom,
        );
        if (result != null) {
          var file = File(result.files.single.path!);
          var text = file.readAsStringSync();
          context.read(editableRecordProvider).state =
              context.read(editableRecordProvider).state.copyWith(text: text);
          context.read(historyProvider).append(text);
        }
        Navigator.pop(context);
      },
    );
  }
}

class _DeleteRecordTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.delete),
        title: Text("Удалить"),
        onTap: () async {
          if (await _showConfirmDialog(context) ?? false) {
            await context
                .read(diaryRecordControllerProvider.notifier)
                .delete(context.read(editableRecordProvider).state);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        });
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
