import 'package:flutter_test/flutter_test.dart';
import 'package:cvicebnice/tasks/additions/leveltree.dart';

/// tests using matchers: http://dartdoc.takyam.com/articles/dart-unit-tests/#matchers

void main() {
  group("When generating levels", () {
    LevelTree levelTree = LevelTree();
    test("Generated values should:", () {
      levelTree.levels.forEach((level) {
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

          if (level.solution.length > 3) {
            expect(
                level.solution[3],
                inInclusiveRange(level.valueRange[0],
                    level.valueRange[1])); // test min and max range of z
          }
        }
      });
    });
  });
}