import 'package:flutter/material.dart';

String getLastLine(String str, {int? position}) {
  var strFromNewline = position != null
      ? str.substring(str.substring(0, position).lastIndexOf("\n") + 1)
      : str.substring(str.lastIndexOf("\n") + 1);

  int? nextNewlineOrNull = strFromNewline.indexOf("\n");
  nextNewlineOrNull = nextNewlineOrNull == -1 ? null : nextNewlineOrNull;

  var strBetweenNewlines = strFromNewline.substring(0, nextNewlineOrNull);

  return strBetweenNewlines;
}

TextSelection getLineSelection(String str, {int? position}) {
  var fromNewline =
      str.substring(0, position ?? str.length).lastIndexOf("\n") + 1;

  var strFromNewline = str.substring(fromNewline);

  var toNewline = strFromNewline.indexOf("\n");
  toNewline = toNewline == -1 ? str.length : (fromNewline + toNewline);

  return TextSelection(
    baseOffset: fromNewline,
    extentOffset: toNewline,
  );
}

String getPreviousLine(String str, {required int position}) {
  if (position == -1) return "";

  var beforePosition = str.substring(0, position);

  var beforePositionNewline = beforePosition.lastIndexOf("\n");
  if (beforePositionNewline == -1) return "";
  var beforeNewline = beforePosition.substring(0, beforePositionNewline);

  var previousLineStart = beforeNewline.lastIndexOf("\n");
  previousLineStart = previousLineStart == -1 ? 0 : previousLineStart;
  var previousLine = beforeNewline.substring(previousLineStart);
  return previousLine;
}
