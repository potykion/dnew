import 'dart:io';

import 'package:dnew/logic/diary/controllers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    var state = useState(ToolbarState.initial);
    useValueChanged<bool, void>(textFocused, (_, __) {
      if (!textFocused) {
        state.value = ToolbarState.initial;
      }
    });

    Widget buildInitialToolbar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: textFocused ? 1 : 0,
            child: IconButton(
              icon: Icon(Icons.text_fields),
              onPressed:
                  textFocused ? () => state.value = ToolbarState.md : null,
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.undo), onPressed: null),
              IconButton(icon: Icon(Icons.redo), onPressed: null),
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
      height: 40,
      child: state.value == ToolbarState.initial
          ? buildInitialToolbar()
          : MarkdownToolbar(
              controller: textTec,
              showBackBtn: true,
              onBack: () => state.value = ToolbarState.initial,
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
          context.read(editableRecordProvider).state = context
              .read(editableRecordProvider)
              .state
              .copyWith(text: file.readAsStringSync());
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
            context
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