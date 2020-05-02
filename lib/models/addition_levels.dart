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

class LevelTree{
  /// random generator initialize
  static Random rnd = Random();

  ///
  ///  generates int number 0..maximum : inclusive
  ///
  static int random(int maximum) {
    if (maximum == 0) return 0;
    return rnd.nextInt(maximum + 1);
  }

  ///  Generates int number minimum..maximum : inclusive
  ///
  ///  If max < or = min returns min
  static int randomMinMax(int minimum, int maximum) {
    if (maximum <= minimum) return minimum;
    return rnd.nextInt(maximum - minimum + 1) + minimum;
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
      index: 40,
      onGenerate: () {
        int x = randomMinMax(1, 9);
        int y = randomMinMax(1, 9);
        int w = randomMinMax(
            (x + y) > 10 ? 1 : 11 - (x + y), (x + y) < 10 ? 9 : 19 - (x + y));
        return [x, y, w, x + y + w];
      },
      masks: ["x+y+w=Z"],
      valueRange: [0, 19],
      description:
          "Součet více jednociferných čísel s přechodem přes 10 s celkovým součtem do 20.",
      example: "5 + 4 + 9 = ?",
    ),

    Level(
      index: 41,
      onGenerate: () {
        int k = randomMinMax(1, 9)*10;
        int x = 100 - k;
        return [k, x];
      },
      masks: ["100=k+X"],
      valueRange: [0, 99],
      description:
          "Rozklad čísla 100, kde 1. sčítanec je dělitelný 10.",
      example: "100 = 60 + x",
    ),

    Level(
      index: 42,
      onGenerate: () {
        int k = randomMinMax(1, 19)*5;
        int x = 100 - k;
        return [k, x];
      },
      masks: ["100=k+X"],
      valueRange: [0, 99],
      description:
      "Rozklad čísla 100, kde 1. sčítanec je dělitelný 5.",
      example: "100 = 75 + x",
    ),

    Level(
      index: 43,
      onGenerate: () {
        int k = random(1) == 1 ? randomMinMax(1, 19)*5 : randomMinMax(91, 99);
        int x = 100 - k;
        return [k, x];
      },
      masks: ["100=k+X"],
      valueRange: [0, 99],
      description:
      "Rozklad čísla 100, kde 1. sčítanec je dělitelný 5 a nebo 91-99.",
      example: "100 = 92 + x",
    ),


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

    Level(
      index: 146,
      onGenerate: () {
        int xt = randomMinMax(1, 8);
        int yt = randomMinMax(1, 9 - xt);

        int xo = randomMinMax(1, 8);
        int yo = randomMinMax(1, 9 - xo);

        // randomize position (ones / tens) of the lower generated values
        int onesOrTens = random(1) == 1 ? 10 : 1; // or random(1)*9 + 1  :)

        int x = xt * 1000 + xo * onesOrTens;
        int y = yt * 1000 + yo * onesOrTens;

        return [x, y, null, x + y];
      },
      masks: ["x+y=Z"],
      valueRange: [0, 9999],
      description: "Všechna čísla z úlohy jsou 4 cif. čísla, "
          "dvě z jejich cifer jsou vždy 0 - buď řády J+S nebo D + S a to tak, "
          "že součet čísel sčítanců v daných řádech je vždy ≤ 9, "
          "celkový součet je < 10000.",
      example: "4005 + 3004 = ?",
    ),

    Level(
      index: 150,
      onGenerate: () {
        int xt = randomMinMax(1, 8);
        int yt = randomMinMax(1, 9 - xt);

        int xh = randomMinMax(1, 8);
        int yh = randomMinMax(1, 9 - xh);

        int x = xt * 1000 + xh * 100;
        int y = yt * 1000 + yh * 100;

        return [x, y, null, x + y];
      },
      masks: ["x+y=Z"],
      valueRange: [0, 9999],
      description: "Všechna čísla z úlohy jsou 4 cif. čísla, "
          "dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, "
          "že součet čísel sčítanců v daných řádech je vždy ≤ 9, "
          "celkový součet je < 10000.",
      example: "1200 + 1300 = ?",
    ),

    // ///////////////// end of levels
  ];
}
