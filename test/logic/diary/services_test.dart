import 'package:dnew/logic/diary/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test tags parse", () {
    expect(parseTags("").toList(), <String>[]);
    expect(parseTags("#").toList(), <String>[]);
    expect(parseTags("#sam").toList(), <String>["#sam"]);
    expect(parseTags("#sam #").toList(), <String>["#sam"]);
    expect(parseTags("#ass #s #художка").toList(), <String>["#ass", "#s", "#художка"]);

    expect(parseTags("", matchEmpty: true).toList(), <String>[]);
    expect(parseTags("#", matchEmpty: true).toList(), <String>["#"]);
    expect(parseTags("#sam #", matchEmpty: true).toList(), <String>["#sam", "#"]);
  });
}
