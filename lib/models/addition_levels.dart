import 'dart:core';

///
/// Level generator for the math additions
///

import 'dart:math';

//////////////////////////////////////////////// Level generator //////////////////////////////

class Level {
  int index;
  int variables;

  List<int> Function() onGenerate;
  List<int> solution;

  Level({this.index, this.onGenerate});

  static Random rnd = Random();

//  10 steps

  void generate() {
    solution = onGenerate();
    print(solution);
  }
}

///
/// ///////////////////////// Tree of levels (incl. definitions) //////////////////////////////
///

class LevelTree {
  /// random generator initialize
  static Random rnd = Random();

  ///
  ///  generates number 0..maximum : inclusive
  ///
  static int random(int maximum) {
    if (maximum == 0) return 0;
    return rnd.nextInt(maximum + 1);
  }

  static Level getLevelByLevelIndex(int levelIndex) {
    return LevelTree.levels.singleWhere(
            (level) => level.index == levelIndex,
        orElse: () => null);
  }

  ///
  /// ///////////////////////////////////////////////// level definitions
  ///
  static final List<Level> levels = [

    Level(
        index: 134,
        onGenerate: () {
          int x = random(7) + 1;
          int y = random(8 - x) + 1;
          return [x*1000, y*1000, null, (x+y)*1000];
        }),

    Level(
        index: 138,
        onGenerate: () {
          int x = (random(8) + 1) * 1000;
          int y = random(899) + 100;
          return [x, y, null, x+y];
        }),
    Level(
        index: 139,
        onGenerate: () => getLevelByLevelIndex(138).onGenerate()),

    Level(
        index: 142,
        onGenerate: () {
          int y = (random(7) + 1) * 1000;
          int x = random(8999 - y) + 1000;
          return [x, y, null, x+y];
        }),



    // ///////////////// end of levels
  ];
}
