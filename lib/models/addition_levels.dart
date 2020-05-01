import 'dart:core';
import 'package:flutter/foundation.dart';

///
/// Level generator for the math additions
///

import 'dart:math';
import 'contract_level.dart';

//////////////////////////////////////////////// Level generator //////////////////////////////

class Level extends LevelContract {
  /// callback to generator function, which should return the list of generated values for task and solution
  List<int> Function() onGenerate;

  /// Collection of masks to be applied onto task
  ///
  /// Capital letter (e.g. Z in x+y=Z) means input place => x+y=?
  /// Small letters (x, y, in x+y=Z) means visible number
  /// If there are more than 1 mask, one of them is selected during the task generation
  List<String> masks;

  /// Declared range limit on generated values - used in unit tests
  List<int> valueRange;

  /// Human description
  String description;

  /// Printable example
  String example;

  /// Generated values typically x,y,w,z
  List<int> solution;

  /// Selected mask for UI
  int _selectedTaskMask = 0;

  /// Constructor
  Level(
      {@required index,
      @required this.onGenerate,
      this.masks,
      @required this.valueRange,
      this.description,
      this.example})
      : super(index: index);

  /// random generator
  static Random rnd = Random();

  // TODO make 10 tasks
  /// Generate 10 tasks for 1 level
  @override
  void generate() {
    solution = onGenerate();
    _selectedTaskMask = rnd.nextInt(masks.length);
  }

  @override
  String toString() =>
      "level: $index - $solution - ${masks[_selectedTaskMask]}";
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

  static Level getLevelByIndex(int levelIndex) {
    return LevelTree.levels
        .singleWhere((level) => level.index == levelIndex, orElse: () => null);
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
        return [x * 1000, y * 1000, null, (x + y) * 1000];
      },
      masks: [
        "x+y=Z",
      ],
      valueRange: [0, 9999],
      description:
          "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
      example: "6000 + 3000 = ?",
    ),
    Level(
      index: 135,
      onGenerate: () => getLevelByIndex(134).onGenerate(),
      masks: [
        "x+Y=z",
      ],
      valueRange: [0, 9999],
      description:
          "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
      example: "6000 + ? = 9000",
    ),
    Level(
      index: 136,
      onGenerate: () => getLevelByIndex(134).onGenerate(),
      masks: [
        "X+y=z",
      ],
      valueRange: [0, 9999],
      description:
          "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
      example: "6000 + ? = 9000",
    ),
    Level(
      index: 137,
      onGenerate: () => getLevelByIndex(134).onGenerate(),
      masks: ["x+Y=z", "X+y=z"],
      valueRange: [0, 9999],
      description:
          "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
      example: "6000 + ? = 9000, nebo ? + 3000 = 9000",
    ),
    Level(
      index: 138,
      onGenerate: () {
        int x = (random(8) + 1) * 1000;
        int y = random(899) + 100;
        return [x, y, null, x + y];
      },
      masks: [
        "x+y=Z",
      ],
      valueRange: [0, 9999],
      description:
          "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
      example: "4000 + 358 = ?",
    ),

    Level(
      index: 139,
      onGenerate: () => getLevelByIndex(138).onGenerate(),
      masks: [
        "x+Y=z",
      ],
      valueRange: [0, 9999],
      description:
          "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
      example: "4000 + ? = 4358",
    ),

    Level(
      index: 140,
      onGenerate: () => getLevelByIndex(138).onGenerate(),
      masks: ["X+y=z"],
      valueRange: [0, 9999],
      description:
          "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
      example: "? + 358 = 4358",
    ),

    Level(
      index: 141,
      onGenerate: () => getLevelByIndex(138).onGenerate(),
      masks: ["x+Y=z", "X+y=z"],
      valueRange: [0, 9999],
      description:
          "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
      example: "4000 + ? = 4358, nebo ? + 358 = 4358",
    ),

    Level(
      index: 142,
      onGenerate: () {
        int y = (random(7) + 1) * 1000;
        int x = random(8999 - y) + 1000;
        return [x, y, null, x + y];
      },
      masks: ["x+Y=z"],
      valueRange: [0, 9999],
      description:
          "1. sčítanec je 4 ciferné číslo, 2. sčítanec je 4 ciferné číslo dělitelné 1000, součet je < 10000.",
      example: "4321 + ? = 6321",
    ),

    // ///////////////// end of levels
  ];
}
