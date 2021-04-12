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
  toNewline =
      toNewline == -1 ? str.length : (fromNewline + toNewline);

  return TextSelection(
    baseOffset: fromNewline,
    extentOffset: toNewline,
  );
}
