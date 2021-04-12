import 'package:dnew/logic/core/utils/str.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("getLastLine", () {
    expect(getLastLine("ass"), "ass");
    expect(getLastLine("ass\ntities"), "tities");
    expect(getLastLine("ass\ntities\nbeer", position: 5), "tities");
    expect(getLastLine("##\n\n###", position: 3), "");
  });

  test("getLineSelection", () {
    expect(getLineSelection("ass").textInside("ass"), "ass");
    expect(getLineSelection("ass\ntities").textInside("ass\ntities"), "tities");
    expect(
        getLineSelection("ass\ntities\nbeer", position: 5)
            .textInside("ass\ntities\nbeer"),
        "tities");
    expect(
        getLineSelection("##\n\n###", position: 3).textInside("##\n\n###"), "");

    expect(getLineSelection("#\n\n##", position: 1).textInside("#\n\n##"), "#");
  });

  test("getPreviousLine", () {
    expect(getPreviousLine("ass\ntities", position: 4), "ass");
    expect(getPreviousLine("##\n\n###", position: 3), "##");

  });
}
