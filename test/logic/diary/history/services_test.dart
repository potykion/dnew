import 'package:dnew/logic/diary/history/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("History undo", () {
    var initialText = "initial";
    var history = History()..init(initialText);
    history.append("text");

    var text = history.undo();
    expect(text, initialText);
  });

  test("History undo 2", () {
    var initialText = "Op";
    var history = History()..init(initialText);
    history.append("O");
    history.append("");

    var text = history.undo();
    expect(text, "O");
    text = history.undo();
    expect(text, "Op");
  });

  test("History redo", () {
    var initialText = "initial";
    var appendText = "append";
    var history = History()..init(initialText);
    history.append(appendText);
    history.undo();

    var text = history.redo();

    expect(text, appendText);
  });
}
