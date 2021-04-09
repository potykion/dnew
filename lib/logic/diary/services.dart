Iterable<String> parseTags(String str, {bool matchEmpty = false}) =>
    RegExp(matchEmpty ? r"(#[\wа-яА-Я]+|#)" : r"(#[\wа-яА-Я]+)")
        .allMatches(str)
        .map((m) => m.group(0)!);
