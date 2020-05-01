import 'package:flutter_test/flutter_test.dart';

import 'package:cvicebnice/models/addition_levels.dart';

/// tests using matchers: http://dartdoc.takyam.com/articles/dart-unit-tests/#matchers

void main() {
  group("When generating levels", () {
    test("Generated values should:", () {
      LevelTree.levels.forEach((level) {
//        var level = LevelTree.getLevelByIndex(135);
        for (var i = 0; i < 2; i++) {
          level.generate();
          //        print("level ${level.index}: ${level.solution}");
          print(level);
          expect(
              level.solution[0],
              inInclusiveRange(level.valueRange[0],
                  level.valueRange[1])); // test min and max range of x
          expect(
              level.solution[1],
              inInclusiveRange(level.valueRange[0],
                  level.valueRange[1])); // test min and max range of y
          expect(
              level.solution[3],
              inInclusiveRange(level.valueRange[0],
                  level.valueRange[1])); // test min and max range of z
        }
      });
    });
  });
}
