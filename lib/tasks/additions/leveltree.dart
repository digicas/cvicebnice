//
// Level generator for the math additions tasks
//

import 'dart:core';
import '../core/level.dart';
import 'level.dart';

/// ///////////////////////// Tree of levels (incl. definitions) //////////////////////////////
///
/// At least one instance must be created otherwise level definitions are not generated
class LevelTree extends LevelTreeBlueprint {
  /// Collection of defined levels
  ///
  List<Level> levels;

  /// Constructor , which also generates the collection of levels
  LevelTree() {
    levels = levelBuilder();
  }

  /// Must be static, so cannot be inherited
  static int random(int maximum) => LevelTreeBlueprint.random(maximum);

  /// Must be static, so cannot be inherited
  static int randomMinMax(int minimum, int maximum) =>
      LevelTreeBlueprint.randomMinMax(minimum, maximum);

  /// Returns [Level] by searching given index or null if not found
  Level getLevelByIndex(int levelIndex) {
    return levels.singleWhere((level) => level.index == levelIndex,
        orElse: () => null);
  }

  /// Returns true if level exists in LevelTree, false otherwise
  bool levelExists(int levelIndex) {
    return getLevelByIndex(levelIndex) != null;
  }

  /// Returns more difficult [Level] if there is any or the same one
  Level getMoreDifficultLevel(Level level) {
    Level newLevel;
    int newLevelIndex = level.index;

    /// avoid not implemented levels
    while (newLevel == null) {
      newLevelIndex++;

      /// max level -> return the same level
      if (level.index == levels.last.index) return level;
      newLevel = getLevelByIndex(newLevelIndex);
    }
    return newLevel;
  }

  /// returns less difficult level if there is any
  Level getLessDifficultLevel(Level level) {
    int newLevelIndex = level.index;
    Level newLevel;

    /// avoid not implemented levels
    while (newLevel == null) {
      newLevelIndex--;

      /// min level -> return the same level
      if (newLevelIndex == 0) return level;
      newLevel = getLevelByIndex(newLevelIndex);
    }
    return newLevel;
  }

  /// ////////////////////////////////////////////// level definitions builder
  ///
  List<Level> levelBuilder() {
    return [
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
          int k = randomMinMax(1, 9) * 10;
          int x = 100 - k;
          return [k, x];
        },
        masks: ["100=k+X"],
        valueRange: [0, 99],
        description: "Rozklad čísla 100, kde 1. sčítanec je dělitelný 10.",
        example: "100 = 60 + ?",
      ),

      Level(
        index: 42,
        onGenerate: () {
          int k = randomMinMax(1, 19) * 5;
          int x = 100 - k;
          return [k, x];
        },
        masks: ["100=k+X"],
        valueRange: [0, 99],
        description: "Rozklad čísla 100, kde 1. sčítanec je dělitelný 5.",
        example: "100 = 75 + ?",
      ),

      Level(
        index: 43,
        onGenerate: () {
          int k =
              random(1) == 1 ? randomMinMax(1, 19) * 5 : randomMinMax(81, 99);
          int x = 100 - k;
          return [k, x];
        },
        masks: ["100=k+X"],
        valueRange: [0, 99],
        description:
            "Rozklad čísla 100, kde 1. sčítanec je dělitelný 5 a nebo 81-99.",
        example: "100 = 92 + ?",
      ),

      Level(
        index: 134,
        onGenerate: () {
          int x = random(7) + 1;
          int y = random(8 - x) + 1;
          return [x * 1000, y * 1000, (x + y) * 1000];
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
          return [x, y, x + y];
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
          return [x, y, x + y];
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

          return [x, y, x + y];
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

          return [x, y, x + y];
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
  } // end of level builder

} // end of LevelTree class
