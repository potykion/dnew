import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
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
