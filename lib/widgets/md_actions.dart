import 'dart:convert';

import 'package:dnew/logic/core/utils/str.dart';
import 'package:flutter/material.dart';

class KeyboardMarkdownActions extends StatelessWidget {
  final bool isSelectionActions;
  final String initialText;
  final TextSelection initialSelection;
  final Function(String text, TextSelection selection) onAction;

  const KeyboardMarkdownActions({
    Key? key,
    this.isSelectionActions = false,
    required this.onAction,
    required this.initialText,
    required this.initialSelection,
  }) : super(key: key);

  void wrapWithMarkdown(String markdown) {
    var selectionEnd = initialSelection.extentOffset;

    var beforeSelection = initialText.substring(0, initialSelection.baseOffset);
    var selection = initialText.substring(
      initialSelection.baseOffset,
      initialSelection.extentOffset,
    );
    var afterSelection = initialText.substring(initialSelection.extentOffset);

    onAction(
      "$beforeSelection$markdown$selection$markdown$afterSelection",
      TextSelection(
        baseOffset: selectionEnd + markdown.length * 2,
        extentOffset: selectionEnd + markdown.length * 2,
      ),
    );
  }

  void wrapWithMarkdownLink() {
    var selectionEnd = initialSelection.extentOffset;

    var beforeSelection = initialText.substring(0, initialSelection.baseOffset);
    var selection = initialText.substring(
        initialSelection.baseOffset, initialSelection.extentOffset);
    var afterSelection = initialText.substring(initialSelection.extentOffset);

    onAction(
      "$beforeSelection[$selection]()$afterSelection",
      TextSelection(
        baseOffset: selectionEnd + 3, // 3 = [](|)
        extentOffset: selectionEnd + 3,
      ),
    );
  }

  void addHeader([String header = "#"]) {
    var lineSelection = getLineSelection(
      initialText,
      position: initialSelection.baseOffset,
    );

    var headerText = initialText.isEmpty
        ? "$header \n"
        : lineSelection.textInside(initialText).isEmpty
            ? "\n$header \n"
            : "\n\n$header \n";

    var beforeHeading = initialText.substring(0, initialSelection.baseOffset);
    var afterHeading = initialText.substring(lineSelection.extentOffset);
    var newText = "$beforeHeading$headerText$afterHeading";

    var newSelection = TextSelection(
      baseOffset: initialSelection.baseOffset + headerText.length - 1,
      extentOffset: initialSelection.baseOffset + headerText.length - 1,
    );

    onAction(newText, newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            if (isSelectionActions) ...[
              IconButton(
                icon: Icon(Icons.format_bold),
                onPressed: () => wrapWithMarkdown("**"),
              ),
              IconButton(
                icon: Icon(Icons.format_italic),
                onPressed: () => wrapWithMarkdown("*"),
              ),
              IconButton(
                icon: Icon(Icons.format_strikethrough),
                onPressed: () => wrapWithMarkdown("~~"),
              ),
              IconButton(
                icon: Icon(Icons.code),
                onPressed: () => wrapWithMarkdown("``"),
              ),
              IconButton(
                icon: Icon(Icons.link),
                onPressed: wrapWithMarkdownLink,
              ),
            ] else ...[
              SmallTextButton(
                text: "H1",
                onPressed: () => addHeader("#"),
              ),
              SmallTextButton(
                text: "H2",
                onPressed: () => addHeader("##"),
              ),
              SmallTextButton(
                text: "H3",
                onPressed: () => addHeader("###"),
              ),
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () => addHeader("-"),
              ),
              IconButton(
                icon: Icon(Icons.check_box),
                onPressed: () => onAction(
                  "$initialText- [ ] ",
                  TextSelection(
                    baseOffset: initialSelection.extentOffset + "- [ ] ".length,
                    extentOffset:
                        initialSelection.extentOffset + "- [ ] ".length,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.format_quote),
                onPressed: () => onAction(
                  "$initialText> ",
                  TextSelection(
                    baseOffset: initialSelection.extentOffset + "> ".length,
                    extentOffset: initialSelection.extentOffset + "> ".length,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.code),
                onPressed: () => onAction(
                  "$initialText```\n\n```",
                  TextSelection(
                    baseOffset: initialSelection.extentOffset + "```\n".length,
                    extentOffset:
                        initialSelection.extentOffset + "```\n".length,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class SmallTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const SmallTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: TextButton(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
