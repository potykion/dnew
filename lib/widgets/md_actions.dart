import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dnew/logic/core/utils/str.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

class KeyboardMarkdownActions extends HookWidget {
  final TextEditingController controller;

  const KeyboardMarkdownActions({
    Key? key,
    required this.controller,
  }) : super(key: key);

  void wrapWithMarkdown(String markdown) {
    var selectionEnd = controller.selection.extentOffset;

    var beforeSelection =
        controller.text.substring(0, controller.selection.baseOffset);
    var selection = controller.text.substring(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
    );
    var afterSelection =
        controller.text.substring(controller.selection.extentOffset);

    controller.text =
        "$beforeSelection$markdown$selection$markdown$afterSelection";
    controller.selection = TextSelection(
      baseOffset: selectionEnd + markdown.length * 2,
      extentOffset: selectionEnd + markdown.length * 2,
    );
  }

  void wrapWithMarkdownLink() {
    var selectionEnd = controller.selection.extentOffset;

    var beforeSelection =
        controller.text.substring(0, controller.selection.baseOffset);
    var selection = controller.text.substring(
        controller.selection.baseOffset, controller.selection.extentOffset);
    var afterSelection =
        controller.text.substring(controller.selection.extentOffset);

    controller.text = "$beforeSelection[$selection]()$afterSelection";
    controller.selection = TextSelection(
      baseOffset: selectionEnd + 3, // 3 = [](|)
      extentOffset: selectionEnd + 3,
    );
  }

  void addMarkdown([String markdown = "#", String extra = ""]) {
    var lineSelection = getLineSelection(
      controller.text,
      position: controller.selection.baseOffset,
    );

    var headerText = controller.text.isEmpty
        ? "$markdown \n"
        : lineSelection.textInside(controller.text).isEmpty
            ? "\n$markdown \n"
            : "\n\n$markdown \n";

    var beforeHeading =
        controller.text.substring(0, controller.selection.baseOffset);
    var afterHeading = controller.text.substring(lineSelection.extentOffset);
    var newText = "$beforeHeading$headerText$extra$afterHeading";

    var newSelection = TextSelection(
      baseOffset: controller.selection.baseOffset + headerText.length - 1,
      extentOffset: controller.selection.baseOffset + headerText.length - 1,
    );

    controller.text = newText;
    controller.selection = newSelection;
  }

  @override
  Widget build(BuildContext context) {
    var isSelectionActions = useState(false);

    // Если выделили текст, то показываем экшены для выделенного теста
    useEffect(
      () {
        // ignore: prefer_function_declarations_over_variables
        var listener = () {
          if (controller.selection.baseOffset == -1) return;
          var textSelected = controller.selection.baseOffset !=
              controller.selection.extentOffset;
          isSelectionActions.value = textSelected;
        };
        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
      [],
    );

    return Container(
      height: 50,
      color: Theme.of(context).canvasColor,
      child: Material(
        color: Colors.transparent,
        child: ListView(
          // shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            if (isSelectionActions.value) ...[
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
                onPressed: () => addMarkdown("#"),
              ),
              SmallTextButton(
                text: "H2",
                onPressed: () => addMarkdown("##"),
              ),
              SmallTextButton(
                text: "H3",
                onPressed: () => addMarkdown("###"),
              ),
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () => addMarkdown("-"),
              ),
              IconButton(
                icon: Icon(Icons.format_list_numbered),
                onPressed: () => addMarkdown("1."),
              ),
              IconButton(
                icon: Icon(Icons.check_box),
                onPressed: () => addMarkdown("- [ ]"),
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () async {
                  PickedFile? img = await ImagePicker().getImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );

                  if (img != null) {
                    File file = File(img.path);
                    var filename = img.path.split("/").last;
                    var ref = firebase_storage.FirebaseStorage.instance.ref(
                      'uploads/${FirebaseAuth.instance.currentUser!.uid}/$filename',
                    );
                    await ref.putFile(file);
                    var imgUrl = await ref.getDownloadURL();
                    addMarkdown("![img]($imgUrl)");
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.format_quote),
                onPressed: () => addMarkdown(">"),
              ),
              IconButton(
                icon: Icon(Icons.code),
                onPressed: () => addMarkdown("```\n", "```\n"),
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

Tuple2<String, TextSelection>? tryContinueMarkdownList(
    String initialText, TextSelection initialSelection) {
  var cursor = initialSelection.baseOffset;
  if (cursor == -1) return null;

  var prevLine = getPreviousLine(initialText, position: cursor).trim();

  var prevListItemIsEmpty = prevLine != "- [ ]" &&
      prevLine != "- [x]" &&
      prevLine != "-" &&
      !RegExp(r"\d+\.$").hasMatch(prevLine);
  if (!prevListItemIsEmpty) {
    return null;
  }

  var beforeCursor = initialText.substring(0, cursor);
  var afterCursor = initialText.substring(cursor);
  if (prevLine.startsWith("- [ ]") || prevLine.startsWith("- [x]")) {
    return Tuple2(
      "$beforeCursor- [ ] $afterCursor",
      TextSelection(
        baseOffset: cursor + "- [ ] ".length,
        extentOffset: cursor + "- [ ] ".length,
      ),
    );
  } else if (prevLine.startsWith("-")) {
    return Tuple2(
      "$beforeCursor- $afterCursor",
      TextSelection(
        baseOffset: cursor + "- ".length,
        extentOffset: cursor + "- ".length,
      ),
    );
  } else if (RegExp(r"^\d+\.\s").hasMatch(prevLine)) {
    var prevNum = int.parse(prevLine.substring(0, prevLine.indexOf(".")));

    return Tuple2(
      "$beforeCursor${prevNum + 1}. $afterCursor",
      TextSelection(
        baseOffset: cursor + "${prevNum + 1}. ".length,
        extentOffset: cursor + "${prevNum + 1}. ".length,
      ),
    );
  }
}
