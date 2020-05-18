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

  /// Gets the levelIndex in [LevelTree] based on whole xid "abcghi"
  ///
  /// Returns -1 if levelIndex is not found.
  int getLevelIndexFromXid(String wholeXid) {
    if (wholeXid == null) return -1;
    if (wholeXid.length < 6 ) return -1;
    var levelXid = wholeXid.substring(3, 6).toLowerCase();
    int i = levels.indexWhere((level) => level.xid == levelXid);
    return levels[i].index;
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

  /// Returns level Index number based on the given school year and month
  static int schoolClassToLevelIndex(int schoolClass, int monthInSchool) {
    assert(schoolClass > -1); // 0 schoolClass is tutorial
    assert(monthInSchool > -1 && monthInSchool < 10); // 0..Sept, 9..June
    schoolClass =
    (schoolClass > 5) ? 5 : schoolClass; // highest defined schoolClass

    return schoolClassToLevelMap[schoolClass][monthInSchool];
  }

  /// Lookup map to find levels based on school year and month
  ///
  /// each row is the schoolClass (0-5)
  /// each column is the schoolMonth (0-9)
  // @formatter:off
  static final List<List<int>> schoolClassToLevelMap = [
    //09   10   11   12   01   02   03   04   05   06 -- months in the school year
    [ 00,  00,  00,  00,  00,  00,  00,  00,  00,  00], // 0 class => tutorial
    [ 02,  02,  06,  10,  15,  15,  20,  25,  30,  30], // 1st class
    [ 36,  41,  44,  55,  59,  64,  72,  76,  77,  77], // 2nd
    [ 65,  73,  73,  78,  79,  90,  94, 114, 126, 126], // 3rd
    [118, 130, 130, 170, 170, 170, 180, 180, 180, 180], // 4th
    [180, 180, 180, 180, 180, 180, 180, 180, 180, 180], // 5th
  ]; //@formatter:on


  /// ////////////////////////////////////////////// level definitions builder
  ///
  List<Level> levelBuilder() {
    return [
      Level(
        index: 2,
        xid: "btx",
        onGenerate: () {
          int x = randomMinMax(0, 5);
          int y = randomMinMax(1, 6 - x);
          return [[x, y, x + y], [y, x, x + y]][random(1)];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 6],
        description: "Sčítání v číselném oboru 0 - 6.",
        example: "4 + 2 = ?",
      ),

      Level(
        index: 3,
        xid: "bzx",
        onGenerate: () {
          int z = randomMinMax(3, 6);
          int x = randomMinMax(0, z-1);
          return [[x, z-x, z], [z-x, x, z]][random(1)];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 6],
        description: "Sčítání v číselném oboru 0 - 6.",
        example: "4 + ? = 6",
      ),

      Level(
        index: 4,
        xid: "bfr",
        onGenerate: () {
          int z = randomMinMax(3, 6);
          int x = randomMinMax(0, z-1);
          return [[x, z-x, z], [z-x, x, z]][random(1)];
        },
        masks: ["X+y=z"],
        valueRange: [0, 6],
        description: "Sčítání v číselném oboru 0 - 6.",
        example: "? + 2 = 6",
      ),

      Level(
        index: 5,
        xid: "bwj",
        onGenerate: () {
          int z = randomMinMax(3, 6);
          int x = randomMinMax(0, z-1);
          return [[x, z-x, z], [z-x, x, z]][random(1)];
        },
        masks: ["X+y=z", "x+Y=z"],
        valueRange: [0, 6],
        description: "Sčítání v číselném oboru 0 - 6.",
        example: "? + 2 = 6, případně 3 + ? = 5",
      ),


      Level(
        index: 6,
        xid: "esv",
        onGenerate: () {
          int z = randomMinMax(4, 9);
          int x = randomMinMax(0, z);
          return [[x, z-x, z],[z-x, x, z]][random(1)];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 9],
        description: "Sčítání v číselném oboru 0 - 9.",
        example: "4 + 5 = ?",
      ),
      Level(
        index: 7,
        xid: "bed",
        onGenerate: () {
          int z = randomMinMax(4, 9);
          int x = randomMinMax(0, z);
          return [[x, z-x, z],[z-x, x, z]][random(1)];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 9],
        description: "Sčítání v číselném oboru 0 - 9.",
        example: "4 + ? = 9",
      ),
      Level(
        index: 8,
        xid: "czd",
        onGenerate: () {
          int z = randomMinMax(4, 9);
          int x = randomMinMax(0, z);
          return [[x, z-x, z],[z-x, x, z]][random(1)];
        },
        masks: ["X+y=z"],
        valueRange: [0, 9],
        description: "Sčítání v číselném oboru 0 - 9.",
        example: "? + 5 = 9",
      ),

      Level(
        index: 9,
        xid: "dnw",
        onGenerate: () {
          int z = randomMinMax(4, 9);
          int x = randomMinMax(0, z);
          return [[x, z-x, z],[z-x, x, z]][random(1)];
        },
        masks: ["X+y=z", "x+Y=z"],
        valueRange: [0, 9],
        description: "Sčítání v číselném oboru 0 - 9.",
        example: "4 + ? = 9, nebo 5 + ? = 9",
      ),

      Level(
        index: 10,
        xid: "dfe",
        onGenerate: () {
          int z = randomMinMax(5, 10);
          int x = randomMinMax(0, z);
          return [x, z-x, z];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 10],
        description: "Sčítání v číselném oboru 0 - 10.",
        example: "4 + 6 = ?",
      ),

      Level(
        index: 11,
        xid: "aiq",
        onGenerate: () {
          int z = randomMinMax(5, 10);
          int x = randomMinMax(0, z);
          return [x, z-x, z];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 10],
        description: "Sčítání v číselném oboru 0 - 10.",
        example: "4 + ? = 10",
      ),
      Level(
        index: 12,
        xid: "gcg",
        onGenerate: () {
          int z = randomMinMax(5, 10);
          int x = randomMinMax(0, z);
          return [x, z-x, z];
        },
        masks: ["X+y=z"],
        valueRange: [0, 10],
        description: "Sčítání v číselném oboru 0 - 10.",
        example: "? + 6 = 10",
      ),
      Level(
        index: 13,
        xid: "eoh",
        onGenerate: () {
          int z = randomMinMax(5, 10);
          int x = randomMinMax(0, z);
          return [x, z-x, z];
        },
        masks: ["x+Y=z", "X+y=z"],
        valueRange: [0, 10],
        description: "Sčítání v číselném oboru 0 - 10.",
        example: "4 + ? = 10, nebo ? + 5 = 9",
      ),

      Level(
        index: 14,
        xid: "eoh",
        onGenerate: () {
          int z = randomMinMax(5, 10);
          int a = randomMinMax(2, z - 1);
          int b = randomMinMax(0, z - a);
          int c = z - (a + b);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ["x+y+w=ZZ"],
        valueRange: [0, 10],
        description:
        "Sčítání v číselném oboru 0 - 10 více čísel.",
        example: "2 + 1 + 5 = ?",
      ),

      Level(
        index: 15,
        xid: "fht",
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
        xid: "ddq",
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
        xid: "acf",
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
        xid: "bwr",
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
        xid: "fos",
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
        xid: "cik",
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
        xid: "fhr",
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
        xid: "bxa",
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
        xid: "fzr",
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
        xid: "ege",
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
        xid: "btj",
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
        xid: "gcd",
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
        xid: "anu",
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
        xid: "erv",
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
        xid: "dot",
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
        index: 30,
        xid: "aka",
        onGenerate: () {
          int x = randomMinMax(2, 9);
          return [x, 11-x, 11];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 11.",
        example: "3 + ? = 11",
      ),

      Level(
        index: 31,
        xid: "byv",
        onGenerate: () {
          int x = randomMinMax(3, 9);
          return [x, 12-x, 12];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 12.",
        example: "4 + ? = 12",
      ),

      Level(
        index: 32,
        xid: "aqg",
        onGenerate: () {
          int z = randomMinMax(11, 13);
          int x = randomMinMax(2, 4);
          return [x, z-x, z];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet do 13, přičemž první sčítanec je v rozsahu 2 - 4.",
        example: "4 + 8 = ?",
      ),


      Level(
        index: 33,
        xid: "cgk",
        onGenerate: () {
          int x = randomMinMax(4, 9);
          return [x, 13-x, 13];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 13.",
        example: "5 + ? = 13",
      ),

      Level(
        index: 34,
        xid: "dnf",
        onGenerate: () {
          int y = randomMinMax(6, 9);
          return [5, y, 5 + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet do 14.",
        example: "5 + 7 = ?",
      ),

      Level(
        index: 35,
        xid: "akc",
        onGenerate: () {
          int x = randomMinMax(5, 9);
          return [x, 14-x, 14];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 14.",
        example: "5 + ? = 14",
      ),

      Level(
        index: 36,
        xid: "cgt",
        onGenerate: () {
          int y = randomMinMax(5, 9);
          return [6, y, 6 + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet do 15.",
        example: "6 + 8 = ?",
      ),

      Level(
        index: 37,
        xid: "eeu",
        onGenerate: () {
          int x = randomMinMax(6, 9);
          return [x, 15-x, 15];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 15.",
        example: "7 + ? = 15",
      ),

      Level(
        index: 38,
        xid: "dcc",
        onGenerate: () {
          int y = randomMinMax(4, 9);
          return [7, y, 7 + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet do 16.",
        example: "7 + 8 = ?",
      ),

      Level(
        index: 39,
        xid: "fod",
        onGenerate: () {
          int y = randomMinMax(3, 9);
          return [8, y, 8 + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet do 17.",
        example: "8 + 5 = ?",
      ),

// //////////////////////////////////////////////////////////////////// Level 40+

      Level(
        index: 40,
        xid: "avw",
        onGenerate: () {
          int y = randomMinMax(2, 9);
          return [9, y, 9 + y];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet do 18.",
        example: "9 + 4 = ?",
      ),


      Level(
        index: 41,
        xid: "biv",
        onGenerate: () {
          int z = randomMinMax(16, 18);
          int x = randomMinMax(z - 10 + 1, 9);
          return [x, z - x, z];

        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description:
        "Sčítání v číselném oboru 0 - 20 s přechodem přes 10, kde je součet 16, 17, 18.",
        example: "9 + ? = 17",
      ),

      Level(
        index: 42,
        xid: "akm",
        onGenerate: () {
          int z = randomMinMax(11, 18);
          int x = randomMinMax(z-9, 9);
          return [x, z-x, z];
        },
        masks: ["x+y=Z"],
        valueRange: [0, 20],
        description: "Sčítání dvou jednociferných čísel s přechodem přes 10.",
        example: "6 + 5 = ?",
      ),

      Level(
        index: 43,
        xid: "chj",
        onGenerate: () {
          int z = randomMinMax(11, 18);
          int x = randomMinMax(z-9, 9);
          return [x, z-x, z];
        },
        masks: ["x+Y=z"],
        valueRange: [0, 20],
        description: "Sčítání dvou jednociferných čísel s přechodem přes 10.",
        example: "6 + ? = 11",
      ),
      Level(
        index: 44,
        xid: "ego",
        onGenerate: () {
          int z = randomMinMax(11, 18);
          int x = randomMinMax(z-9, 9);
          return [x, z-x, z];
        },
        masks: ["X+y=z"],
        valueRange: [0, 20],
        description: "Sčítání dvou jednociferných čísel s přechodem přes 10.",
        example: "? + 5 = 11",
      ),
      Level(
        index: 45,
        xid: "fhf",
        onGenerate: () {
          int z = randomMinMax(11, 18);
          int x = randomMinMax(z-9, 9);
          return [x, z-x, z];
        },
        masks: ["x+Y=z", "X+y=z"],
        valueRange: [0, 20],
        description: "Sčítání dvou jednociferných čísel s přechodem přes 10.",
        example: "6 + ? = 11, nebo ? + 5 = 11",
      ),

      Level(
        index: 46,
        xid: "eud",
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
        index: 47,
        xid: "bkq",
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
        index: 48,
        xid: "fvk",
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
        index: 49,
        xid: "cjg",
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
        example: "100 = 92 + ?, nebo 100 = 55 + ?",
      ),

// //////////////////////////////////////////////////////////////////// Level 50+
// //////////////////////////////////////////////////////////////////// Level 60+
// //////////////////////////////////////////////////////////////////// Level 70+
// //////////////////////////////////////////////////////////////////// Level 80+
// //////////////////////////////////////////////////////////////////// Level 90+

// //////////////////////////////////////////////////////////////////// Level 100+
// //////////////////////////////////////////////////////////////////// Level 110+
// //////////////////////////////////////////////////////////////////// Level 120+
// //////////////////////////////////////////////////////////////////// Level 130+

// //////////////////////////////////////////////////////////////////// Level 140+

      Level(
        index: 140,
        xid: "ejb",
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
        index: 141,
        xid: "ebd",
        onGenerate: () => getLevelByIndex(140).onGenerate(),
        masks: ["x+Y=z"],
        valueRange: [0, 9999],
        description:
        "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
        example: "6000 + ? = 9000",
      ),
      Level(
        index: 142,
        xid: "dnq",
        onGenerate: () => getLevelByIndex(140).onGenerate(),
        masks: ["X+y=z"],
        valueRange: [0, 9999],
        description:
        "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
        example: "6000 + ? = 9000",
      ),
      Level(
        index: 143,
        xid: "cqy",
        onGenerate: () => getLevelByIndex(140).onGenerate(),
        masks: ["x+Y=z", "X+y=z"],
        valueRange: [0, 9999],
        description:
        "Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.",
        example: "6000 + ? = 9000, nebo ? + 3000 = 9000",
      ),
      Level(
        index: 144,
        xid: "cij",
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
        index: 145,
        xid: "ens",
        onGenerate: () => getLevelByIndex(144).onGenerate(),
        masks: ["x+Y=z"],
        valueRange: [0, 9999],
        description:
        "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
        example: "4000 + ? = 4358",
      ),

      Level(
        index: 146,
        xid: "fwk",
        onGenerate: () => getLevelByIndex(144).onGenerate(),
        masks: ["X+y=z"],
        valueRange: [0, 9999],
        description:
        "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
        example: "? + 358 = 4358",
      ),

      Level(
        index: 147,
        xid: "ckz",
        onGenerate: () => getLevelByIndex(144).onGenerate(),
        masks: ["x+Y=z", "X+y=z"],
        valueRange: [0, 9999],
        description:
        "1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.",
        example: "4000 + ? = 4358, nebo ? + 358 = 4358",
      ),

      Level(
        index: 148,
        xid: "adq",
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

// //////////////////////////////////////////////////////////////////// Level 150+

      Level(
        index: 152,
        xid: "fnz",
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
        index: 156,
        xid: "csn",
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

// //////////////////////////////////////////////////////////////////// Level 160+

// //////////////////////////////////////////////////////////////////// Level 170+

// //////////////////////////////////////////////////////////////////// Level 180+

// //////////////////////////////////////////////////////////////////// Level 190+

// //////////////////////////////////////////////////////////////////// Level 200+

      // ///////////////// end of levels
    ];
  } // end of level builder

} // end of LevelTree class
