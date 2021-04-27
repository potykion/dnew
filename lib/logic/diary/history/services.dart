import 'dart:collection';

class History {
  final _undoQueue = Queue<String>();
  final _redoQueue = Queue<String>();

  bool get canUndo => _undoQueue.length > 1;

  bool get canRedo => _redoQueue.isNotEmpty;

  void init([String initialText = ""]) {
    _undoQueue.clear();
    _redoQueue.clear();
    _undoQueue.add(initialText);
  }

  void append(String text) {
    _undoQueue.add(text);
    _redoQueue.clear();
  }

  String undo() {
    assert(canUndo);
    _redoQueue.add(_undoQueue.removeLast());
    return _undoQueue.last;
  }

  String redo() {
    assert(canRedo);
    var text = _redoQueue.removeLast();
    _undoQueue.add(text);
    return text;
  }
}
