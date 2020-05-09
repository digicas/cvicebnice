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

  /// Returns more difficult levelIndex if there is any or the same one
  int getMoreDifficultLevelIndex(int currentIndex) {
    Level newLevel;
    int newIndex = currentIndex;

    /// avoid not implemented levels
    while (newLevel == null) {
      newIndex++;

      /// max level -> return the same level index
      if (newIndex > levels.last.index) return currentIndex;
      newLevel = getLevelByIndex(newIndex);
    }

    return newIndex;
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

  /// Returns less difficult levelIndex if there is any or the same one
  int getLessDifficultLevelIndex(int currentIndex) {
    Level newLevel;
    int newLevelIndex = currentIndex;

    /// avoid not implemented levels
    while (newLevel == null) {
      newLevelIndex--;

      /// min level -> return the same level
      if (newLevelIndex == 0) return currentIndex;
      newLevel = getLevelByIndex(newLevelIndex);
    }
    return newLevelIndex;
  }

  /// ////////////////////////////////////////////// level definitions builder
  ///
  List<Level> levelBuilder() {
    return [
      Level(
        index: 2,
        xid: "4p8",
        onGenerate: () {
          int x = randomMinMax(0, 6);
          int y = randomMinMax(0, 6 - x);
          return [x, y, x + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 6],
        description: "Sčítání v číselném oboru 0 - 6.",
        example: "4 + 2 = ?",
      ),

      Level(
        index: 6,
        xid: "34u",
        onGenerate: () {
          int x = randomMinMax(0, 9);
          int y = randomMinMax(0, 9 - x);
          return [x, y, x + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 9],
        description: "Sčítání v číselném oboru 0 - 9.",
        example: "4 + 5 = ?",
      ),

      Level(
        index: 10,
        xid: "2ni",
        onGenerate: () {
          int x = randomMinMax(0, 10);
          int y = randomMinMax(0, 10 - x);
          return [x, y, x + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 10],
        description: "Sčítání v číselném oboru 0 - 10.",
        example: "4 + 6 = ?",
      ),

      Level(
        index: 15,
        xid: "4zk",
        onGenerate: () {
          int x = randomMinMax(10, 14);
          int y = randomMinMax(0, 14 - x);
          return random(1) == 1 ? [x, y, x + y] : [y, x, x + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 14],
        description:
            "Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "11 + 2 = ?",
      ),

      Level(
        index: 16,
        xid: "4ae",
        onGenerate: () {
          int z = randomMinMax(10, 14);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 14],
        description:
            "Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "11 + ? = 14",
      ),

      Level(
        index: 17,
        xid: "3u2",
        onGenerate: () {
          int z = randomMinMax(10, 14);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["X+y=z"],
        valueRange: [0, 14],
        description:
            "Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "? + 5 = 16",
      ),

      Level(
        index: 18,
        xid: "37e",
        onGenerate: () {
          int z = randomMinMax(10, 14);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["X+y=z", "x+Y=z"],
        valueRange: [0, 14],
        description:
            "Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "? + 2 = 13, nebo 4 + ? = 14",
      ),

      Level(
        index: 19,
        xid: "3hc",
        onGenerate: () {
          int z = randomMinMax(11, 14);
          int a = randomMinMax(10, z - 1);
          int b = randomMinMax(0, z - a);
          int c = z - (a + b);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ["x+y+w=ZZ"],
        valueRange: [0, 14],
        description:
            "Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "2 + 1 + 11 = ?",
      ),
// //////////////////////////////////////////////////////////////////// Level 20+

      Level(
        index: 20,
        xid: "3fu",
        onGenerate: () {
          int x = randomMinMax(10, 17);
          int y = randomMinMax(0, 17 - x);
          return random(1) == 1 ? [x, y, x + y] : [y, x, x + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 17],
        description:
            "Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "11 + 2 = ?",
      ),

      Level(
        index: 21,
        xid: "2v8",
        onGenerate: () {
          int z = randomMinMax(10, 17);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 17],
        description:
            "Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "11 + ? = 17",
      ),

      Level(
        index: 22,
        xid: "2ai",
        onGenerate: () {
          int z = randomMinMax(10, 17);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["X+y=z"],
        valueRange: [0, 17],
        description:
            "Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "? + 5 = 16",
      ),

      Level(
        index: 23,
        xid: "3q9",
        onGenerate: () {
          int z = randomMinMax(10, 17);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["X+y=z", "x+Y=z"],
        valueRange: [0, 17],
        description:
            "Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "? + 2 = 13, nebo 4 + ? = 17",
      ),

      Level(
        index: 24,
        xid: "3se",
        onGenerate: () {
          int z = randomMinMax(11, 17);
          int a = randomMinMax(10, z - 1);
          int b = randomMinMax(0, z - a);
          int c = z - (a + b);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ["x+y+w=ZZ"],
        valueRange: [0, 17],
        description:
            "Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "2 + 1 + 11 = ?",
      ),

      Level(
        index: 25,
        xid: "3pj",
        onGenerate: () {
          int x = randomMinMax(10, 20);
          int y = randomMinMax(0, 20 - x);
          return random(1) == 1 ? [x, y, x + y] : [y, x, x + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description:
            "Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "16 + 2 = ?",
      ),

      Level(
        index: 26,
        xid: "3br",
        onGenerate: () {
          int z = randomMinMax(10, 20);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description:
            "Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "11 + ? = 16",
      ),

      Level(
        index: 27,
        xid: "57p",
        onGenerate: () {
          int z = randomMinMax(10, 20);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["X+y=z"],
        valueRange: [0, 20],
        description:
            "Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "? + 5 = 16",
      ),

      Level(
        index: 28,
        xid: "2id",
        onGenerate: () {
          int z = randomMinMax(10, 20);
          int x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ["X+y=z", "x+Y=z"],
        valueRange: [0, 20],
        description:
            "Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "? + 5 = 16, nebo 4 + ? = 15",
      ),

      Level(
        index: 29,
        xid: "3pd",
        onGenerate: () {
          int z = randomMinMax(11, 20);
          int a = randomMinMax(10, z - 1);
          int b = randomMinMax(0, z - a);
          int c = z - (a + b);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ["x+y+w=ZZ"],
        valueRange: [0, 20],
        description:
            "Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je 10 a více.",
        example: "2 + 4 + 12 = ?",
      ),
// //////////////////////////////////////////////////////////////////// Level 30+

      Level(
        index: 35,
        xid: "5bu",
        onGenerate: () {
          int z = randomMinMax(16, 18);
          int x = randomMinMax(z - 10 + 1, 9);
          return [x, z - x, z];

//          int a = randomMinMax(2, 4);
//          int b = randomMinMax(11 - a, 9);
//          return [[x, z-x, z], []][random(1)];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description:
            "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 16, 17, 18.",
        example: "9 + ? = 17",
      ),

// //////////////////////////////////////////////////////////////////// Level 40+
      Level(
        index: 40,
        xid: "5af",
        onGenerate: () {
          int x = randomMinMax(1, 9);
          int y = randomMinMax(1, 9);
          int w = randomMinMax(
              (x + y) > 10 ? 1 : 11 - (x + y), (x + y) < 10 ? 9 : 19 - (x + y));
          return [x, y, w, x + y + w];
        },
        masks: ["x+y+w=ZZ"],
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
        masks: ["x+y=Z"],
        valueRange: [0, 9999],
        description:
            "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
        example: "6000 + 3000 = ?",
      ),

      Level(
        index: 135,
        onGenerate: () => getLevelByIndex(134).onGenerate(),
        masks: ["x+Y=z"],
        valueRange: [0, 9999],
        description:
            "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
        example: "6000 + ? = 9000",
      ),
      Level(
        index: 136,
        onGenerate: () => getLevelByIndex(134).onGenerate(),
        masks: ["X+y=z"],
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
        masks: ["x+y=Z"],
        valueRange: [0, 9999],
        description:
            "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
        example: "4000 + 358 = ?",
      ),

      Level(
        index: 139,
        onGenerate: () => getLevelByIndex(138).onGenerate(),
        masks: ["x+Y=z"],
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
