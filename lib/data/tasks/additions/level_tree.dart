// ignore_for_file: prefer_asserts_with_message, lines_longer_than_80_chars, null_closures, require_trailing_commas, missing_whitespace_between_adjacent_strings

import 'dart:core';
import 'dart:math';

import 'package:cvicebnice/data/tasks/additions/i_level_tree.dart';
import 'package:cvicebnice/data/tasks/additions/level.dart';
import 'package:flutter/foundation.dart';

class LevelTree extends ILevelTree {
  LevelTree() {
    levels = levelBuilder();
  }

  ///
  List<Level> levels = [];

  /// Constructor , which also generates the collection of levels

  /// Must be static, so cannot be inherited
  static int random(int maximum) => ILevelTree.random(maximum);

  /// Must be static, so cannot be inherited
  static int randomMinMax(int minimum, int maximum) =>
      ILevelTree.randomMinMax(minimum, maximum);

  /// Returns [Level] by searching given index or null if not found
  Level? getLevelByIndex(int levelIndex) {
    final result = levels.where((level) => level.index == levelIndex);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// Returns [Level] by searching given xid or null if not found
  Level? getLevelByXid(String xid) {
    final result = levels.where((level) => level.xid == xid);
    if (result.isNotEmpty) return result.first;
    return null;
  }
  // levels.singleWhere((level) => level.xid == xid, orElse: null);

  /// Returns true if level exists in LevelTree, false otherwise
  bool levelExists(int levelIndex) {
    return getLevelByIndex(levelIndex) != null;
  }

  /// Gets the levelIndex in [LevelTree] based on whole xid "abcghi"
  ///
  /// Returns -1 if levelIndex is not found.
  int getLevelIndexFromXid(String wholeXid) {
    if (wholeXid.length < 6) return -1;
    final levelXid = wholeXid.substring(3, 6).toLowerCase();
    final i = levels.indexWhere((level) => level.xid == levelXid);
    return levels[i].index;
  }

  /// Returns more difficult [Level] if there is any or the same one
  Level getMoreDifficultLevel(Level level) {
    Level? newLevel;
    var newLevelIndex = level.index;

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
    Level? newLevel;
    var newIndex = currentIndex;

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
    Level? newLevel;
    var newLevelIndex = level.index;

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
    Level? newLevel;
    var newLevelIndex = currentIndex;

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
    // highest defined schoolClass
    return schoolClassToLevelMap[schoolClass > 5 ? 5 : schoolClass]
        [monthInSchool];
  }

  /// Returns the List of List<int> schoolClass, school month based on the given index
  ///
  /// Can generate more tuples as the references overlap in time
  /// Returns empty [] if the given level index is not int the map
  static List<List<int>> getSchoolClassAndMonth(int levelIndex) {
    final result = <List<int>>[];
    var tmp = [0, 0];

    for (var i = 0; i < schoolClassToLevelMap.length; i++) {
      final yearMap = schoolClassToLevelMap[i];
      final yearIndex = i;
      for (var mi = 0; mi < yearMap.length; mi++) {
        if (yearMap[mi] == levelIndex) {
          // we take only first occurrence in the uninterrupted sequence
          if (!listEquals([yearIndex, mi - 1], tmp)) {
            result.add([yearIndex, mi]);
          }
          tmp = [yearIndex, mi];
        }
      }
    }
//    log(result);
    return result;
  }

  /// Returns the List of List<int> schoolClass, school month based on the given index
  /// additionally to [getSchoolClassAndMonth] if no result is found it returns
  /// the tuples of closest (lower) index
  ///
  /// Can generate more tuples as the references overlap in time
  static List<List<int>> getMinimumSchoolClassAndMonth(int levelIndex) {
    var result = <List<int>>[];
    var li = levelIndex;
    while (result.isEmpty & (li > 0)) {
      result = getSchoolClassAndMonth(li);
      li--;
    }
    assert(
      result.isNotEmpty,
      'Level $levelIndex does not have class/month assigned.',
    );
    return result;
  }

  /// Returns the List of List<int> schoolClass based on the given index
  /// or of the closest lower possible index, if the given index is not found
  /// in the mapping table
  static List<int> getSchoolClasses(int levelIndex) {
    final result = <int>[];

    for (var yIndex = 0; yIndex < schoolClassToLevelMap.length; yIndex++) {
      final y = schoolClassToLevelMap[yIndex];
      final yMin = y.reduce(min);
      final yMax = y.reduce(max);

      if ((yMin <= levelIndex) & (levelIndex <= yMax)) result.add(yIndex);
    }

    assert(
      result.isNotEmpty,
      'Level $levelIndex does not have class assigned.',
    );
    return result;
  }

  /// Lookup map to find levels based on school year and month
  ///
  /// each row is the schoolClass (0-5)
  /// each column is the schoolMonth (0-9)
  // @formatter:off
  static final List<List<int>> schoolClassToLevelMap = [
    //09   10   11   12   01   02   03   04   05   06 -- months in the school year
    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00], // 0 class => tutorial
    [02, 04, 06, 10, 15, 19, 20, 25, 30, 42], // 1st class
    [42, 47, 50, 61, 65, 70, 78, 82, 83, 84], // 2nd
    [70, 78, 83, 85, 86, 97, 101, 121, 125, 133], // 3rd
    [125, 137, 161, 177, 182, 185, 187, 191, 195, 195], // 4th
    [191, 195, 195, 195, 196, 196, 196, 196, 196, 196], // 5th
  ]; //@formatter:on

  /// ////////////////////////////////////////////// level definitions builder
  ///
  List<Level> levelBuilder() {
    return [
      Level(
        index: 2,
        xid: 'btx',
        onGenerate: () {
          final x = randomMinMax(0, 5);
          final y = randomMinMax(1, 6 - x);
          return [
            [x, y, x + y],
            [y, x, x + y]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 6],
        description: 'Sčítání v číselném oboru 0 - 6.',
        example: '4 + 2 = ?',
      ),

      Level(
        index: 3,
        xid: 'bzx',
        onGenerate: () {
          final z = randomMinMax(3, 6);
          final x = randomMinMax(0, z - 1);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 6],
        description: 'Sčítání v číselném oboru 0 - 6.',
        example: '4 + ? = 6',
      ),

      Level(
        index: 4,
        xid: 'bfr',
        onGenerate: () {
          final z = randomMinMax(3, 6);
          final x = randomMinMax(0, z - 1);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['X+y=z'],
        valueRange: [0, 6],
        description: 'Sčítání v číselném oboru 0 - 6.',
        example: '? + 2 = 6',
      ),

      Level(
        index: 5,
        xid: 'bwj',
        onGenerate: () {
          final z = randomMinMax(3, 6);
          final x = randomMinMax(0, z - 1);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['X+y=z', 'x+Y=z'],
        valueRange: [0, 6],
        description: 'Sčítání v číselném oboru 0 - 6.',
        example: '? + 2 = 6, případně 3 + ? = 5',
      ),

      Level(
        index: 6,
        xid: 'esv',
        onGenerate: () {
          final z = randomMinMax(4, 9);
          final x = randomMinMax(0, z);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9],
        description: 'Sčítání v číselném oboru 0 - 9.',
        example: '4 + 5 = ?',
      ),
      Level(
        index: 7,
        xid: 'bed',
        onGenerate: () {
          final z = randomMinMax(4, 9);
          final x = randomMinMax(0, z);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 9],
        description: 'Sčítání v číselném oboru 0 - 9.',
        example: '4 + ? = 9',
      ),
      Level(
        index: 8,
        xid: 'czd',
        onGenerate: () {
          final z = randomMinMax(4, 9);
          final x = randomMinMax(0, z);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['X+y=z'],
        valueRange: [0, 9],
        description: 'Sčítání v číselném oboru 0 - 9.',
        example: '? + 5 = 9',
      ),

      Level(
        index: 9,
        xid: 'dnw',
        onGenerate: () {
          final z = randomMinMax(4, 9);
          final x = randomMinMax(0, z);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['X+y=z', 'x+Y=z'],
        valueRange: [0, 9],
        description: 'Sčítání v číselném oboru 0 - 9.',
        example: '4 + ? = 9, nebo 5 + ? = 9',
      ),

      Level(
        index: 10,
        xid: 'dfe',
        onGenerate: () {
          final z = randomMinMax(6, 10);
          final x = randomMinMax(0, z);
          return [x, z - x, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 10],
        description: 'Sčítání v číselném oboru 0 - 10.',
        example: '4 + 6 = ?',
      ),

      Level(
        index: 11,
        xid: 'aiq',
        onGenerate: () {
          final z = randomMinMax(6, 10);
          final x = randomMinMax(0, z);
          return [x, z - x, z];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 10],
        description: 'Sčítání v číselném oboru 0 - 10.',
        example: '4 + ? = 10',
      ),
      Level(
        index: 12,
        xid: 'gcg',
        onGenerate: () {
          final z = randomMinMax(6, 10);
          final x = randomMinMax(0, z);
          return [x, z - x, z];
        },
        masks: ['X+y=z'],
        valueRange: [0, 10],
        description: 'Sčítání v číselném oboru 0 - 10.',
        example: '? + 6 = 10',
      ),
      Level(
        index: 13,
        xid: 'eoh',
        onGenerate: () {
          final z = randomMinMax(6, 10);
          final x = randomMinMax(0, z);
          return [x, z - x, z];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 10],
        description: 'Sčítání v číselném oboru 0 - 10.',
        example: '4 + ? = 10, nebo ? + 5 = 9',
      ),

      Level(
        index: 14,
        xid: 'frf',
        onGenerate: () {
          final z = randomMinMax(5, 10);
          int a;
          int b;
          int c;
          do {
            a = randomMinMax(2, z - 1);
            b = randomMinMax(1, z - a);
            c = z - (a + b);
          } while (({a, b, c}.length != 3) | ((b + c) == 1));

          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ['x+y+w=ZZ'],
        valueRange: [0, 10],
        description: 'Sčítání tří čísel v číselném oboru 0 - 10.',
        example: '2 + 1 + 5 = ?',
      ),

      Level(
        index: 15,
        xid: 'fht',
        onGenerate: () {
          final x = randomMinMax(10, 14);
          final y = randomMinMax(0, 14 - x);
          return random(1) == 1 ? [x, y, x + y] : [y, x, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 14],
        description:
            'Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '11 + 2 = ?',
      ),

      Level(
        index: 16,
        xid: 'ddq',
        onGenerate: () {
          final z = randomMinMax(10, 14);
          final x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 14],
        description:
            'Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '11 + ? = 14',
      ),

      Level(
        index: 17,
        xid: 'acf',
        onGenerate: () {
          final z = randomMinMax(10, 14);
          final x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ['X+y=z'],
        valueRange: [0, 14],
        description:
            'Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '? + 5 = 16',
      ),

      Level(
        index: 18,
        xid: 'bwr',
        onGenerate: () {
          final z = randomMinMax(10, 14);
          final x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ['X+y=z', 'x+Y=z'],
        valueRange: [0, 14],
        description:
            'Sčítání v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '? + 2 = 13, nebo 4 + ? = 14',
      ),

      Level(
        index: 19,
        xid: 'fos',
        onGenerate: () {
          final z = randomMinMax(11, 14);
          final a = randomMinMax(10, z - 1);
          final b = randomMinMax(0, z - a);
          final c = z - (a + b);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ['x+y+w=ZZ'],
        valueRange: [0, 14],
        description:
            'Obor: 0 - 14\nSčítání tří čísel v číselném oboru 0 - 14 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '2 + 1 + 11 = ?',
      ),
// //////////////////////////////////////////////////////////////////// Level 20+

      Level(
        index: 20,
        xid: 'cik',
        onGenerate: () {
          final x = randomMinMax(11, 17);
          final y = randomMinMax(0, 17 - x);
          return random(1) == 1 ? [x, y, x + y] : [y, x, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 17],
        description:
            'Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '11 + 2 = ?',
      ),

      Level(
        index: 21,
        xid: 'fhr',
        onGenerate: () {
          final z = randomMinMax(11, 17);
          final x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 17],
        description:
            'Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '11 + ? = 17',
      ),

      Level(
        index: 22,
        xid: 'bxa',
        onGenerate: () {
          final z = randomMinMax(11, 17);
          final x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ['X+y=z'],
        valueRange: [0, 17],
        description:
            'Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '? + 5 = 16',
      ),

      Level(
        index: 23,
        xid: 'fzr',
        onGenerate: () {
          final z = randomMinMax(11, 17);
          final x = randomMinMax(10, z);
          return random(1) == 1 ? [x, z - x, z] : [z - x, x, z];
        },
        masks: ['X+y=z', 'x+Y=z'],
        valueRange: [0, 17],
        description:
            'Sčítání v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '? + 2 = 13, nebo 4 + ? = 17',
      ),

      Level(
        index: 24,
        xid: 'ege',
        onGenerate: () {
          final z = randomMinMax(12, 17);
          int a;
          int b;
          int c;
          do {
            a = randomMinMax(10, z - 1);
            b = randomMinMax(0, z - a);
            c = z - (a + b);
          } while ((b + c) < 2);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ['x+y+w=ZZ'],
        valueRange: [0, 17],
        description:
            'Sčítání tří čísel v číselném oboru 0 - 17 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '2 + 1 + 11 = ?',
      ),

      Level(
        index: 25,
        xid: 'btj',
        onGenerate: () {
          final z = randomMinMax(12, 20);
          final x = randomMinMax(10, z);
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description:
            'Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '16 + 2 = ?',
      ),

      Level(
        index: 26,
        xid: 'gcd',
        onGenerate: () => getLevelByXid('btj')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description:
            'Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '11 + ? = 16',
      ),

      Level(
        index: 27,
        xid: 'anu',
        onGenerate: () => getLevelByXid('btj')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 20],
        description:
            'Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '? + 5 = 16',
      ),

      Level(
        index: 28,
        xid: 'erv',
        onGenerate: () => getLevelByXid('btj')!.onGenerate(),
        masks: ['X+y=z', 'x+Y=z'],
        valueRange: [0, 20],
        description:
            'Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '? + 5 = 16, nebo 4 + ? = 15',
      ),

      Level(
        index: 29,
        xid: 'dot',
        onGenerate: () {
          final z = randomMinMax(13, 20);
          int a;
          int b;
          int c;
          do {
            a = randomMinMax(10, z - 1);
            b = randomMinMax(0, z - a);
            c = z - (a + b);
          } while ((b + c) < 2);
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ['x+y+w=ZZ'],
        valueRange: [0, 20],
        description:
            'Sčítání v číselném oboru 0 - 20 bez přechodu přes 10, kde jeden ze sčítanců je ≥ 10.',
        example: '2 + 4 + 12 = ?',
      ),

      Level(
        index: 30,
        xid: 'aka',
        onGenerate: () {
          final x = randomMinMax(2, 9);
          return [x, 11 - x, 11];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet 11.',
        example: '3 + ? = 11',
      ),

      Level(
        index: 31,
        xid: 'byv',
        onGenerate: () {
          final x = randomMinMax(3, 9);
          return [x, 12 - x, 12];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet 12.',
        example: '4 + ? = 12',
      ),

      Level(
        index: 32,
        xid: 'aqg',
        onGenerate: () {
          final z = randomMinMax(11, 13);
          final x = randomMinMax(2, 4);
          return [x, z - x, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description:
            'Sčítání s přechodem přes desítku, kde je součet do 13, přičemž první sčítanec je v rozsahu 2 - 4.',
        example: '4 + 8 = ?',
      ),

      Level(
        index: 33,
        xid: 'cgk',
        onGenerate: () {
          final x = randomMinMax(4, 9);
          return [x, 13 - x, 13];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet 13.',
        example: '5 + ? = 13',
      ),

      Level(
        index: 34,
        xid: 'dnf',
        onGenerate: () {
          final y = randomMinMax(6, 9);
          return [5, y, 5 + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet do 14.',
        example: '5 + 7 = ?',
      ),

      Level(
        index: 35,
        xid: 'akc',
        onGenerate: () {
          final x = randomMinMax(5, 9);
          return [x, 14 - x, 14];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet 14.',
        example: '5 + ? = 14',
      ),

      Level(
        index: 36,
        xid: 'cgt',
        onGenerate: () {
          final y = randomMinMax(5, 9);
          return [6, y, 6 + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet do 15.',
        example: '6 + 8 = ?',
      ),

      Level(
        index: 37,
        xid: 'eeu',
        onGenerate: () {
          final x = randomMinMax(6, 9);
          return [x, 15 - x, 15];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet 15.',
        example: '7 + ? = 15',
      ),

      Level(
        index: 38,
        xid: 'dcc',
        onGenerate: () {
          final y = randomMinMax(4, 9);
          return [7, y, 7 + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet do 16.',
        example: '7 + 8 = ?',
      ),

      Level(
        index: 39,
        xid: 'fod',
        onGenerate: () {
          final y = randomMinMax(3, 9);
          return [8, y, 8 + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet do 17.',
        example: '8 + 5 = ?',
      ),

// //////////////////////////////////////////////////////////////////// Level 40+

      Level(
        index: 40,
        xid: 'avw',
        onGenerate: () {
          final y = randomMinMax(2, 9);
          return [9, y, 9 + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description: 'Sčítání s přechodem přes desítku, kde je součet do 18.',
        example: '9 + 4 = ?',
      ),

      Level(
        index: 41,
        xid: 'biv',
        onGenerate: () {
          final z = randomMinMax(16, 18);
          final x = randomMinMax(z - 10 + 1, 9);
          return [x, z - x, z];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description:
            'Sčítání s přechodem přes desítku, kde je součet 16/17/18.',
        example: '9 + ? = 17',
      ),

      Level(
        index: 42,
        xid: 'akm',
        onGenerate: () {
          final z = randomMinMax(12, 18);
          final x = randomMinMax(z - 9, 9);
          return [x, z - x, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 20],
        description: 'Sčítání dvou jednociferných čísel s přechodem přes 10.',
        example: '6 + 5 = ?',
      ),

      Level(
        index: 43,
        xid: 'chj',
        onGenerate: () {
          final z = randomMinMax(12, 18);
          final x = randomMinMax(z - 9, 9);
          return [x, z - x, z];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 20],
        description: 'Sčítání dvou jednociferných čísel s přechodem přes 10.',
        example: '6 + ? = 11',
      ),
      Level(
        index: 44,
        xid: 'ego',
        onGenerate: () {
          final z = randomMinMax(12, 18);
          final x = randomMinMax(z - 9, 9);
          return [x, z - x, z];
        },
        masks: ['X+y=z'],
        valueRange: [0, 20],
        description: 'Sčítání dvou jednociferných čísel s přechodem přes 10.',
        example: '? + 5 = 11',
      ),
      Level(
        index: 45,
        xid: 'fhf',
        onGenerate: () {
          final z = randomMinMax(12, 18);
          final x = randomMinMax(z - 9, 9);
          return [x, z - x, z];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 20],
        description: 'Sčítání dvou jednociferných čísel s přechodem přes 10.',
        example: '6 + ? = 11, nebo ? + 5 = 11',
      ),

      Level(
        index: 46,
        xid: 'eud',
        onGenerate: () {
          int x;
          int y;
          int w;
          bool again;
          Set<int> xywSet;
          do {
            again = false;
            x = randomMinMax(1, 9);
            y = randomMinMax(1, 9);
            w = randomMinMax((x + y) > 10 ? 1 : 11 - (x + y),
                (x + y) < 10 ? 9 : 19 - (x + y));
            xywSet = {x, y, w};
            if (xywSet.length == 2) {
              // check that if two same numbers => must be > 3
              final check = [x, y, w];
              for (final e in xywSet) {
                check.remove(e);
              }
              if (check[0] < 4) again = true;
            }
          } while (again | (xywSet.length < 2));
          return [x, y, w, x + y + w];
        },
        masks: ['x+y+w=ZZ'],
        valueRange: [0, 19],
        description:
            'Sčítání tří jednociferných čísel v číselném oboru 0 - 20 s přechodem přes 10.',
        example: '5 + 4 + 9 = ?',
      ),

      Level(
        index: 47,
        xid: 'bkq',
        onGenerate: () {
          final k = randomMinMax(1, 9) * 10;
          final x = 100 - k;
          return [k, x];
        },
        masks: ['100=k+X'],
        valueRange: [0, 99],
        description: 'Rozklad čísla 100, kde 1. sčítanec je dělitelný 10.',
        example: '100 = 60 + ?',
      ),

      Level(
        index: 48,
        xid: 'fvk',
        onGenerate: () {
          final k = randomMinMax(1, 19) * 5;
          final x = 100 - k;
          return [k, x];
        },
        masks: ['100=k+X'],
        valueRange: [0, 99],
        description: 'Rozklad čísla 100, kde 1. sčítanec je dělitelný 5.',
        example: '100 = 75 + ?',
      ),

      Level(
        index: 49,
        xid: 'cjg',
        onGenerate: () {
          final k =
              random(1) == 1 ? randomMinMax(1, 19) * 5 : randomMinMax(81, 99);
          final x = 100 - k;
          return [k, x];
        },
        masks: ['100=k+X'],
        valueRange: [0, 99],
        description:
            'Rozklad čísla 100, kde 1. sčítanec je <81..99> nebo dělitelný 5.',
        example: '100 = 92 + ?, nebo 100 = 55 + ?',
      ),

// //////////////////////////////////////////////////////////////////// Level 50+
      Level(
        index: 50,
        xid: 'cqz',
        onGenerate: () {
          var z = randomMinMax(2, 10);
          final x = randomMinMax(0, z - 1) * 10;
          z = z * 10;
          return [
            [x, z - x, z],
            [z - x, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description: 'Obor: 0 - 100\nSčítanci jsou dělitelní 10.',
        example: '20 + 40 = ?',
      ),
      Level(
        index: 51,
        xid: 'aqc',
        onGenerate: () => getLevelByXid('cqz')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description: 'Obor: 0 - 100\nSčítanci jsou dělitelní 10.',
        example: '20 + ? = 70',
      ),
      Level(
        index: 52,
        xid: 'foq',
        onGenerate: () => getLevelByXid('cqz')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description: 'Obor: 0 - 100\nSčítanci jsou dělitelní 10.',
        example: '? + 40 = 70',
      ),

      Level(
        index: 53,
        xid: 'dzh',
        onGenerate: () {
          final x = randomMinMax(2, 9) * 10;
          final y = randomMinMax(1, 9);
          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla dělitelného 10.',
        example: '60 + 4 = ?',
      ),

      Level(
        index: 54,
        xid: 'dwu',
        onGenerate: () => getLevelByXid('dzh')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla dělitelného 10.',
        example: '60 + ? = 64',
      ),
      Level(
        index: 55,
        xid: 'enb',
        onGenerate: () => getLevelByXid('dzh')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla dělitelného 10.',
        example: '? + 4 = 74',
      ),

      Level(
        index: 56,
        xid: 'cdf',
        onGenerate: () => getLevelByXid('dzh')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla dělitelného 10.',
        example: '60 + ? = 64, nebo ? + 4 = 74',
      ),

      Level(
        index: 57,
        xid: 'ajk',
        onGenerate: () {
          final xx = randomMinMax(2, 9) * 10;
          final xo = randomMinMax(1, 8);
          final y = randomMinMax(1, 9 - xo);
          return [xx + xo, y, xx + xo + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla bez přechodu přes desítku.',
        example: '63 + 5 = ?',
      ),

      Level(
        index: 58,
        xid: 'ahe',
        onGenerate: () => getLevelByXid('ajk')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla bez přechodu přes desítku.',
        example: '63 + ? = 68',
      ),
      Level(
        index: 59,
        xid: 'asu',
        onGenerate: () => getLevelByXid('ajk')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla bez přechodu přes desítku.',
        example: '? + 5 = 67',
      ),

// //////////////////////////////////////////////////////////////////// Level 60+
      Level(
        index: 60,
        xid: 'fkp',
        onGenerate: () => getLevelByXid('ajk')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla bez přechodu přes desítku.',
        example: '54 + ? = 58, nebo ? + 5 = 67',
      ),

      Level(
        index: 61,
        xid: 'evc',
        onGenerate: () {
          final xt = randomMinMax(2, 9) * 10;
          final xo = randomMinMax(1, 9);
          final y = 10 - xo;
          return [xt + xo, y, xt + xo + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla, kdy součet je dělitelný 10.',
        example: '63 + 7 = ?',
      ),

      Level(
        index: 62,
        xid: 'fse',
        onGenerate: () => getLevelByXid('evc')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla, kdy součet je dělitelný 10.',
        example: '63 + ? = 70',
      ),
      Level(
        index: 63,
        xid: 'fuf',
        onGenerate: () => getLevelByXid('evc')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla, kdy součet je dělitelný 10.',
        example: '? + 7 = 70',
      ),
      Level(
        index: 64,
        xid: 'awe',
        onGenerate: () => getLevelByXid('evc')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla, kdy součet je dělitelný 10.',
        example: '63 + ? = 70, nebo ? + 7 = 70',
      ),

      Level(
        index: 65,
        xid: 'czx',
        onGenerate: () {
          int xt;
          int xo;
          do {
            xt = randomMinMax(2, 8) * 10;
            xo = randomMinMax(2, 9);
          } while ((xt + xo) < 25);
          final y = randomMinMax(11 - xo, 10 - (xo >> 1));
          return [xt + xo, y, xt + xo + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla s přechodem přes desítku.',
        example: '66 + 5 = ?',
      ),

      Level(
        index: 66,
        xid: 'eyh',
        onGenerate: () => getLevelByXid('czx')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla s přechodem přes desítku.',
        example: '66 + ? = 72',
      ),
      Level(
        index: 67,
        xid: 'bqb',
        onGenerate: () => getLevelByXid('czx')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla s přechodem přes desítku.',
        example: '? + 5 = 84',
      ),
      Level(
        index: 68,
        xid: 'bhj',
        onGenerate: () => getLevelByXid('czx')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet jednociferného a dvojciferného čísla s přechodem přes desítku.',
        example: '66 + ? = 72, nebo ? + 8 = 24',
      ),

      Level(
        index: 69,
        xid: 'cxi',
        onGenerate: () {
          final z = randomMinMax(35, 99);
          final y = randomMinMax(1, 9);
          final x = z - y;

          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+Y=z', 'X+y=z', 'x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet libovolného dvojciferného čísla a libovolného jednociferného čísla.',
        example: 'mix',
      ),

// //////////////////////////////////////////////////////////////////// Level 70+

      Level(
        index: 70,
        xid: 'cno',
        onGenerate: () {
          final zt = randomMinMax(4, 9);
          final zo = randomMinMax(2, 9);
          final xt = randomMinMax(1, zt - 1);
          final xo = randomMinMax(1, zo - 1);
          final y = zt * 10 + zo - xt * 10 - xo;
          return [xt * 10 + xo, y, zt * 10 + zo];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel bez přechodu desítek.',
        example: '66 + 23 = ?',
      ),

      Level(
        index: 71,
        xid: 'ccy',
        onGenerate: () => getLevelByXid('cno')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel bez přechodu desítek.',
        example: '64 + ? = 68',
      ),

      Level(
        index: 72,
        xid: 'edf',
        onGenerate: () => getLevelByXid('cno')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel bez přechodu desítek.',
        example: '? + 25 = 47',
      ),
      Level(
        index: 73,
        xid: 'fkj',
        onGenerate: () => getLevelByXid('cno')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel bez přechodu desítek.',
        example: '64 + ? = 68, nebo ? + 25 = 47',
      ),

      Level(
        index: 74,
        xid: 'fhe',
        onGenerate: () {
          final zt = randomMinMax(4, 10);
          final xt = randomMinMax(1, zt - 2);
          final xo = randomMinMax(1, 9);
          final y = zt * 10 - xt * 10 - xo;
          return [xt * 10 + xo, y, zt * 10];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel, kde součet je dělitelný 10.',
        example: '56 + 24 = ?',
      ),

      Level(
        index: 75,
        xid: 'dtw',
        onGenerate: () => getLevelByXid('fhe')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel, kde součet je dělitelný 10.',
        example: '56 + ? = 80',
      ),
      Level(
        index: 76,
        xid: 'esf',
        onGenerate: () => getLevelByXid('fhe')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel, kde součet je dělitelný 10.',
        example: '? + 24 = 80',
      ),
      Level(
        index: 77,
        xid: 'dyz',
        onGenerate: () => getLevelByXid('fhe')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel, kde součet je dělitelný 10.',
        example: '56 + ? = 80, nebo ? + 24 = 80',
      ),

      Level(
        index: 78,
        xid: 'eyf',
        onGenerate: () {
          final zt = randomMinMax(4, 9);
          final zo = randomMinMax(1, 8);
          final xt = randomMinMax(1, zt - 2);
          final xo = randomMinMax(zo + 1, 9);
          final y = zt * 10 + zo - xt * 10 - xo;
          return [xt * 10 + xo, y, zt * 10 + zo];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel s přechodem přes desítku.',
        example: '57 + 28 = ?',
      ),

      Level(
        index: 79,
        xid: 'fja',
        onGenerate: () => getLevelByXid('eyf')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel s přechodem přes desítku.',
        example: '57 + ? = 74',
      ),

// //////////////////////////////////////////////////////////////////// Level 80+
      Level(
        index: 80,
        xid: 'gaz',
        onGenerate: () => getLevelByXid('eyf')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel s přechodem přes desítku.',
        example: '? + 26 = 74',
      ),
      Level(
        index: 81,
        xid: 'ewu',
        onGenerate: () => getLevelByXid('eyf')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou dvojciferných čísel s přechodem přes desítku.',
        example: '57 + ? = 74, nebo ? + 64 = 83',
      ),

      Level(
        index: 82,
        xid: 'cpr',
        onGenerate: () {
          final z = randomMinMax(40, 84);
          final x = randomMinMax(11, z - 12);
          final y = z - x;
          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+Y=z', 'X+y=z', 'x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet libovolných dvou dvojciferných čísel.',
        example: 'mix',
      ),

      Level(
        index: 83,
        xid: 'aqj',
        onGenerate: () {
          final z = randomMinMax(50, 100);
          final x = randomMinMax(11, z - 12);
          final y = z - x;
          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+Y=z', 'X+y=z', 'x+y=Z'],
        valueRange: [0, 100],
        description:
            'Obor: 0 - 100\nSoučet dvou libovolných dvojciferných čísel.',
        example: 'mix',
      ),

      Level(
        index: 84,
        xid: 'bxj',
        onGenerate: () {
          int a;
          int b;
          int c;
          final z = randomMinMax(5, 9) * 10 + randomMinMax(0, 9);
          do {
            a = randomMinMax(1, z ~/ 10 - 3) * 10 + randomMinMax(1, 9);
            b = randomMinMax(11, z - a - 11);
            c = z - (a + b);
          } while ((b.remainder(10) == 0) || (c.remainder(10) == 0));
          return [
            [a, b, c, z],
            [b, c, a, z],
            [c, a, b, z]
          ][random(2)];
        },
        masks: ['x+y+w=ZZ'],
        valueRange: [0, 100],
        description:
            'Obor 0-100\nSoučet tří dvojciferných čísel s přechodem přes desítku.',
        example: '47 + 18 + 26 = ?',
      ),

      Level(
        index: 85,
        xid: 'csp',
        onGenerate: () {
          final x = randomMinMax(10, 90) * 10;
          final y = 1000 - x;
          return [x, y, 1000];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nRozklad 1000. První sčítanec je trojciferné číslo dělitelné deseti.',
        example: '570 + ? = 1000',
      ),
      Level(
        index: 86,
        xid: 'buf',
        onGenerate: () {
          final zh = randomMinMax(2, 10);
          final xh = randomMinMax(1, zh - 1);
          final yh = zh - xh;
          return [
            [xh * 100, yh * 100, zh * 100],
            [yh * 100, xh * 100, zh * 100]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel dělitelných 100.',
        example: '500 + 200 = ?',
      ),
      Level(
        index: 87,
        xid: 'bak',
        onGenerate: () => getLevelByXid('buf')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel dělitelných 100.',
        example: '500 + ? = 700',
      ),
      Level(
        index: 88,
        xid: 'atf',
        onGenerate: () => getLevelByXid('buf')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel dělitelných 100.',
        example: '? + 400 = 700',
      ),
      Level(
        index: 89,
        xid: 'fmc',
        onGenerate: () {
          final x = randomMinMax(1, 9) * 100;
          final y = randomMinMax(1, 99);
          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla dělitelného 100 a jedno/ dvojciferného čísla.',
        example: '500 + 27 = ?',
      ),
      Level(
        index: 90,
        xid: 'aih',
        onGenerate: () => getLevelByXid('fmc')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla dělitelného 100 a jedno/ dvojciferného čísla.',
        example: '500 + ? = 543',
      ),

// //////////////////////////////////////////////////////////////////// Level 90+
      Level(
        index: 91,
        xid: 'awd',
        onGenerate: () => getLevelByXid('fmc')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla dělitelného 100 a jedno/ dvojciferného čísla.',
        example: '? + 43 = 543',
      ),

      Level(
        index: 92,
        xid: 'ayf',
        onGenerate: () => getLevelByXid('fmc')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla dělitelného 100 a jedno/ dvojciferného čísla.',
        example: '500 + ? = 543, nebo ? + 78 = 678',
      ),
      Level(
        index: 93,
        xid: 'dcb',
        onGenerate: () {
          var x = randomMinMax(11, 98) * 10 + randomMinMax(2, 9);
          if ((100 * (x ~/ 100) + 100) - x < 9) x = x - 25;

          final y = random(1) == 0
              ? randomMinMax(11 - x.remainder(10), 9)
              : ((randomMinMax(10, (100 * (x ~/ 100) + 100) - x)) ~/ 10) * 10;
          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla a čísla jedno/dvojciferného dělitelného 10 bez přechodu řádu stovek.',
        example: '725 + 9 = ?, resp. 631 + 20 = ?',
      ),
      Level(
        index: 94,
        xid: 'bxi',
        onGenerate: () => getLevelByXid('dcb')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla a čísla jedno/dvojciferného dělitelného 10 bez přechodu řádu stovek.',
        example: '725 + ? = 731, resp. 631 + ? = 661',
      ),
      Level(
        index: 95,
        xid: 'ftt',
        onGenerate: () => getLevelByXid('dcb')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla a čísla jedno/dvojciferného dělitelného 10 bez přechodu řádu stovek.',
        example: '? + 8 = 731, resp. ? + 30 = 661',
      ),
      Level(
        index: 96,
        xid: 'axt',
        onGenerate: () => getLevelByXid('dcb')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla a čísla jedno/dvojciferného dělitelného 10 bez přechodu řádu stovek.',
        example: '725 + ? = 731, resp. ? + 20 = 661',
      ),

      Level(
        index: 97,
        xid: 'bza',
        onGenerate: () {
          final zh = randomMinMax(1, 9);
          final zt = randomMinMax(5, 9);
          final zo = randomMinMax(3, 9);
          final z = zh * 100 + zt * 10 + zo;

          final xt = randomMinMax(1, zt - 1);
          final xo = randomMinMax(1, zo - 1);
          final x = zh * 100 + xt * 10 + xo;

          return [x, z - x, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla bez přechodu řádů.',
        example: '726 + 51 = ?',
      ),

      Level(
        index: 98,
        xid: 'brr',
        onGenerate: () => getLevelByXid('bza')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla bez přechodu řádů.',
        example: '726 + ? = 777',
      ),
      Level(
        index: 99,
        xid: 'enk',
        onGenerate: () => getLevelByXid('bza')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla bez přechodu řádů.',
        example: '? + 51 = 777',
      ),
      Level(
        index: 100,
        xid: 'dqn',
        onGenerate: () => getLevelByXid('bza')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla bez přechodu řádů.',
        example: '726 + ? = 777, nebo ? + 51 = 777',
      ),

// //////////////////////////////////////////////////////////////////// Level 100+
      Level(
        index: 101,
        xid: 'djp',
        onGenerate: () {
          final xh = randomMinMax(1, 9);
          final xt = randomMinMax(1, 7);
          final xo = randomMinMax(2, 9);
          final x = xh * 100 + xt * 10 + xo;

          final yt = randomMinMax(1, 8 - xt);
          final yo = randomMinMax(11 - xo, 9);
          final y = yt * 10 + yo;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla s přechodem přes desítku.',
        example: '236 + 18 = ?',
      ),
      Level(
        index: 102,
        xid: 'ant',
        onGenerate: () => getLevelByXid('djp')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla s přechodem přes desítku.',
        example: '236 + ? = 254',
      ),
      Level(
        index: 103,
        xid: 'fyy',
        onGenerate: () => getLevelByXid('djp')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla s přechodem přes desítku.',
        example: '? + 18 = 254',
      ),
      Level(
        index: 104,
        xid: 'dzf',
        onGenerate: () => getLevelByXid('djp')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a dvojciferného čísla s přechodem přes desítku.',
        example: '236 + ? = 254, nebo ? + 18 = 254',
      ),

      Level(
        index: 105,
        xid: 'ejg',
        onGenerate: () {
          final xh = randomMinMax(1, 9);
          final xt = randomMinMax(1, 9);
          final xo = randomMinMax(0, 9);
          final x = xh * 100 + xt * 10 + xo;
          final z = ((x ~/ 100) + 1) * 100;
          return [x, z - x, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jedno/dvojciferného čísla, kde součet je dělitelný 100.',
        example: '254 + 46 = ?',
      ),
      Level(
        index: 106,
        xid: 'cwk',
        onGenerate: () => getLevelByXid('ejg')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jedno/dvojciferného čísla, kde součet je dělitelný 100.',
        example: '254 + ? = 300',
      ),
      Level(
        index: 107,
        xid: 'fim',
        onGenerate: () => getLevelByXid('ejg')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jedno/dvojciferného čísla, kde součet je dělitelný 100.',
        example: '? + 78 = 300',
      ),
      Level(
        index: 108,
        xid: 'ftg',
        onGenerate: () => getLevelByXid('ejg')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jedno/dvojciferného čísla, kde součet je dělitelný 100.',
        example: '254 + ? = 300, nebo ? + 78 = 300',
      ),
      Level(
        index: 109,
        xid: 'aia',
        onGenerate: () {
          final xh = randomMinMax(1, 8);
          const xt = 9;
          final xo = randomMinMax(2, 9);
          final x = xh * 100 + xt * 10 + xo;
          final y = randomMinMax(11 - xo, 9);
          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jednociferného čísla s přechodem přes řády desítek i stovek.',
        example: '294 + 9 = ?',
      ),
      Level(
        index: 110,
        xid: 'cyh',
        onGenerate: () => getLevelByXid('aia')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jednociferného čísla s přechodem přes řády desítek i stovek.',
        example: '294 + ? = 302',
      ),

// //////////////////////////////////////////////////////////////////// Level 110+
      Level(
        index: 111,
        xid: 'efg',
        onGenerate: () => getLevelByXid('aia')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jednociferného čísla s přechodem přes řády desítek i stovek.',
        example: '? + 9 = 305',
      ),
      Level(
        index: 112,
        xid: 'eks',
        onGenerate: () => getLevelByXid('aia')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného a jednociferného čísla s přechodem přes řády desítek i stovek.',
        example: '294 + ? = 302, nebo ? + 9 = 305',
      ),
      Level(
        index: 113,
        xid: 'ftn',
        onGenerate: () {
          int x;
          int xh;
          int xt;
          int xo;
          int y;
          int z;

          xh = randomMinMax(1, 8);
          xt = randomMinMax(1, 9);
          xo = randomMinMax(1, 9);

          x = xh * 100 + xt * 10 + xo;
          y = randomMinMax(10 - xt, 9) * 10;
          z = x + y;

          return [x, y, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem dělitelným 10 s přechodem přes řád stovek.',
        example: '467 + 80 = ?',
      ),
      Level(
        index: 114,
        xid: 'bqv',
        onGenerate: () => getLevelByXid('ftn')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem dělitelným 10 s přechodem přes řád stovek.',
        example: '467 + ? = 537',
      ),
      Level(
        index: 115,
        xid: 'ajd',
        onGenerate: () => getLevelByXid('ftn')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem dělitelným 10 s přechodem přes řád stovek.',
        example: '? + 60 = 537',
      ),
      Level(
        index: 116,
        xid: 'dum',
        onGenerate: () => getLevelByXid('ftn')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem dělitelným 10 s přechodem přes řád stovek.',
        example: '467 + ? = 537, nebo ? + 60 = 537',
      ),
      Level(
        index: 117,
        xid: 'adv',
        onGenerate: () {
          int x;
          int xh;
          int xt;
          int xo;
          int y;
          int z;

          xh = randomMinMax(1, 8);
          xt = randomMinMax(1, 9);
          xo = randomMinMax(1, 9);

          x = xh * 100 + xt * 10 + xo;
          y = (randomMinMax(10 - xt, 9) * 10) + (randomMinMax(1, 9));
          z = x + y;

          return [x, y, z];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem s přechodem přes řád stovek.',
        example: '467 + 85 = ?',
      ),

      Level(
        index: 118,
        xid: 'add',
        onGenerate: () => getLevelByXid('adv')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem s přechodem přes řád stovek.',
        example: '467 + ? = 534',
      ),
      Level(
        index: 119,
        xid: 'abm',
        onGenerate: () => getLevelByXid('adv')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem s přechodem přes řád stovek.',
        example: '? + 459 = 534',
      ),
      Level(
        index: 120,
        xid: 'cqm',
        onGenerate: () => getLevelByXid('adv')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet trojciferného čísla s dvojciferným číslem s přechodem přes řád stovek.',
        example: '467 + ? = 534, nebo ? + 459 = 534',
      ),

// //////////////////////////////////////////////////////////////////// Level 120+
      Level(
        index: 121,
        xid: 'dpe',
        onGenerate: () {
          int x;
          int xh;
          int xt;
          int xo;
          int y;
          int yh;
          int yt;
          int yo;
          int z;

          xh = randomMinMax(1, 8);
          xt = 0;
          xo = 0;
          x = xh * 100 + xt * 10 + xo;

          yh = randomMinMax(1, 9 - xh);
          yt = randomMinMax(0, 9);
          yo = randomMinMax(1, 9);
          y = yh * 100 + yt * 10 + yo;

          z = x + y;

          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '400 + 185 = ?',
      ),

      Level(
        index: 122,
        xid: 'axu',
        onGenerate: () => getLevelByXid('dpe')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '134 + ??? = 534',
      ),
      Level(
        index: 123,
        xid: 'cde',
        onGenerate: () => getLevelByXid('dpe')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '??? + 400 = 534',
      ),
      Level(
        index: 124,
        xid: 'atu',
        onGenerate: () => getLevelByXid('dpe')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '400 + ? = 534, nebo ? + 134 = 534',
      ),
      Level(
        index: 125,
        xid: 'edh',
        onGenerate: () {
          int x;
          int xh;
          int xt;
          int xo;
          int y;
          int yh;
          int yt;
          int yo;
          int z;

          xh = randomMinMax(1, 8);
          xt = randomMinMax(0, 9);
          xo = randomMinMax(0, 9);
          x = xh * 100 + xt * 10 + xo;

          yh = randomMinMax(1, 8 - xh);
          yt = randomMinMax(0, 9 - xt);
          yo = randomMinMax(1, 9 - xo);
          y = yh * 100 + yt * 10 + yo;

          z = x + y;

          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel bez přechodu přes řády.',
        example: '413 + 185 = ?',
      ),
      Level(
        index: 126,
        xid: 'feo',
        onGenerate: () => getLevelByXid('edh')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '212 + ??? = 534',
      ),
      Level(
        index: 127,
        xid: 'ewm',
        onGenerate: () => getLevelByXid('edh')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '??? + 212 = 534',
      ),
      Level(
        index: 128,
        xid: 'aeg',
        onGenerate: () => getLevelByXid('edh')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel, kdy jedno z nich je dělitelné 100.',
        example: '412 + ? = 534, nebo ? + 312 = 534',
      ),

      Level(
        index: 129,
        xid: 'ayo',
        onGenerate: () {
          int x;
          int xh;
          int xt;
          int xo;
          int y;
          int yh;
          int yt;
          int yo;
          int z;

          xh = randomMinMax(1, 8);
          xt = randomMinMax(2, 9);
          xo = randomMinMax(2, 9);
          x = xh * 100 + xt * 10 + xo;

          yh = randomMinMax(1, 8 - xh);
          yt = randomMinMax(11 - xt, 9);
          yo = randomMinMax(11 - xo, 9);
          y = yh * 100 + yt * 10 + yo;

          z = x + y;

          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel s přechodem přes řády desítek i stovek.',
        example: '483 + 188 = ???',
      ),
// //////////////////////////////////////////////////////////////////// Level 130+
      Level(
        index: 130,
        xid: 'fpf',
        onGenerate: () => getLevelByXid('ayo')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel s přechodem přes řády desítek i stovek.',
        example: '483 + ??? = 542',
      ),
      Level(
        index: 131,
        xid: 'ccb',
        onGenerate: () => getLevelByXid('ayo')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel s přechodem přes řády desítek i stovek.',
        example: '??? + 483 = 542',
      ),
      Level(
        index: 132,
        xid: 'fbz',
        onGenerate: () => getLevelByXid('ayo')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou trojciferných čísel s přechodem přes řády desítek i stovek.',
        example: '475 + ? = 654, nebo ??? + 395 = 534',
      ),

      Level(
        index: 133,
        xid: 'btk',
        onGenerate: () {
          int x;
          int xh;
          int xt;
          int xo;
          int y;
          int yh;
          int yt;
          int yo;
          int z;

          xh = randomMinMax(1, 8);
          xt = randomMinMax(0, 9);
          xo = randomMinMax(0, 9);
          x = xh * 100 + xt * 10 + xo;

          yh = randomMinMax(1, 8 - xh);

          do {
            yt = randomMinMax(0, 9);
            yo = randomMinMax(0, 9);
          } while (((yt + xt) == 10) | ((yo + xo) == 10));

          y = yh * 100 + yt * 10 + yo;

          z = x + y;

          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou libovolných trojciferných čísel.',
        example: '483 + 388 = ???',
      ),

      Level(
        index: 134,
        xid: 'cfg',
        onGenerate: () => getLevelByXid('fpf')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou libovolných trojciferných čísel.',
        example: '483 + ??? = 542',
      ),
      Level(
        index: 135,
        xid: 'evm',
        onGenerate: () => getLevelByXid('fpf')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou libovolných trojciferných čísel.',
        example: '483 + ??? = 542',
      ),
      Level(
        index: 136,
        xid: 'bne',
        onGenerate: () => getLevelByXid('fpf')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 1000],
        description:
            'Obor: 0 - 1000\nSoučet dvou libovolných trojciferných čísel.',
        example: '475 + ??? = 654, nebo ??? + 395 = 534',
      ),

      Level(
        index: 137,
        xid: 'eyq',
        onGenerate: () {
          int x;
          int y;
          int z;

          x = randomMinMax(1, 9) * 1000;
          y = randomMinMax(1, 9) * [1, 10, 100][random(2)];

          z = x + y;

          return [
            [x, y, z],
            [y, x, z]
          ][random(1)];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 10000],
        description:
            'Obor: 0 - 10000\nSoučet 4 ciferného čísla dělitelného 1000 a čísla 1/2/3 ciferného dělitelného 1/10/100.',
        example: '4000 + 27 = ???',
      ),
      Level(
        index: 138,
        xid: 'eex',
        onGenerate: () => getLevelByXid('eyq')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 10000],
        description:
            'Obor: 0 - 10000\nSoučet 4 ciferného čísla dělitelného 1000 a čísla 1/2/3 ciferného dělitelného 1/10/100.',
        example: '4000 + ??? = 4042',
      ),
      Level(
        index: 139,
        xid: 'frk',
        onGenerate: () => getLevelByXid('eyq')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 10000],
        description:
            'Obor: 0 - 10000\nSoučet 4 ciferného čísla dělitelného 1000 a čísla 1/2/3 ciferného dělitelného 1/10/100.',
        example: '?? + 42 = 5042',
      ),

// //////////////////////////////////////////////////////////////////// Level 140+
      Level(
        index: 140,
        xid: 'dry',
        onGenerate: () => getLevelByXid('eyq')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 10000],
        description:
            'Obor: 0 - 10000\nSoučet 4 ciferného čísla dělitelného 1000 a čísla 1/2/3 ciferného dělitelného 1/10/100.',
        example: '4000 + ? = 4654, nebo ??? + 395 = 3395',
      ),

      Level(
        index: 141,
        xid: 'ejb',
        onGenerate: () {
          final x = random(7) + 1;
          final y = random(8 - x) + 1;
          return [x * 1000, y * 1000, (x + y) * 1000];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description:
            'Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.',
        example: '6000 + 3000 = ?',
      ),

      Level(
        index: 142,
        xid: 'ebd',
        onGenerate: () => getLevelByXid('ejb')!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description:
            'Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.',
        example: '6000 + ? = 9000',
      ),
      Level(
        index: 143,
        xid: 'dnq',
        onGenerate: () => getLevelByXid('ejb')!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description:
            'Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.',
        example: '6000 + ? = 9000',
      ),
      Level(
        index: 144,
        xid: 'cqy',
        onGenerate: () => getLevelByXid('ejb')!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description:
            'Oba sčítanci jsou 4 ciferná čísla dělitelná 1000 s hodnotou v rozsahu 0 až 10000.',
        example: '6000 + ? = 9000, nebo ? + 3000 = 9000',
      ),
      Level(
        index: 145,
        xid: 'cij',
        onGenerate: () {
          final x = (random(8) + 1) * 1000;
          final y = random(899) + 100;
          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.',
        example: '4000 + 358 = ?',
      ),

      Level(
        index: 146,
        xid: 'ens',
        onGenerate: () => getLevelByIndex(144)!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.',
        example: '4000 + ? = 4358',
      ),

      Level(
        index: 147,
        xid: 'fwk',
        onGenerate: () => getLevelByIndex(144)!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo dělitelné 1000 s hodnotou v rozsahu 0 až 10000. 2. sčítanec je 3 ciferné číslo.',
        example: '? + 358 = 4358',
      ),

      Level(
        index: 148,
        xid: 'ckz',
        onGenerate: () => getLevelByIndex(144)!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description: '1. sčítanec je 4 ciferné číslo dělitelné 1000.\n'
            '2. sčítanec je 3 ciferné číslo.\n'
            'Nepřekračuje se přes tisícovky.',
        example: '4000 + ? = 4358, nebo ? + 358 = 4358',
      ),

      Level(
        index: 149,
        xid: 'adq',
        onGenerate: () {
          final y = (random(7) + 1) * 1000;
          final x = random(8999 - y) + 1000;
          return [x, y, x + y];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo, 2. sčítanec je 4 ciferné číslo dělitelné 1000, součet je < 10000.',
        example: '4321 + ? = 6321',
      ),

// //////////////////////////////////////////////////////////////////// Level 150+

      Level(
        index: 150,
        xid: 'fpq',
        onGenerate: () {
          final y = (random(7) + 1) * 1000;
          final x = random(8999 - y) + 1000;
          return [x, y, x + y];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo, 2. sčítanec je 4 ciferné číslo dělitelné 1000, součet je < 10000.',
        example: '4321 + ? = 6321',
      ),

      Level(
        index: 151,
        xid: 'bvf',
        onGenerate: () {
          final y = (random(7) + 1) * 1000;
          final x = random(8999 - y) + 1000;
          return [x, y, x + y];
        },
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo, 2. sčítanec je 4 ciferné číslo dělitelné 1000, součet je < 10000.',
        example: '? + 2000 = 6321',
      ),

      Level(
        index: 152,
        xid: 'bta',
        onGenerate: () {
          final y = (random(7) + 1) * 1000;
          final x = random(8999 - y) + 1000;
          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description:
            '1. sčítanec je 4 ciferné číslo, 2. sčítanec je 4 ciferné číslo dělitelné 1000, součet je < 10000.',
        example: '4321 + ? = 6321, nebo ? + 2000 = 6321',
      ),

      Level(
        index: 153,
        xid: 'fnz',
        onGenerate: () {
          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final xo = randomMinMax(1, 8);
          final yo = randomMinMax(1, 9 - xo);

          // randomize position (ones / tens) of the lower generated values
          final onesOrTens = random(1) == 1 ? 10 : 1; // or random(1)*9 + 1  :)

          final x = xt * 1000 + xo * onesOrTens;
          final y = yt * 1000 + yo * onesOrTens;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer jsou vždy 0 - buď řády J+S nebo D + S a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '4005 + 3004 = ?',
      ),

      Level(
        index: 154,
        xid: 'fzk',
        onGenerate: () => getLevelByIndex(153)!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer jsou vždy 0 - buď řády J+S nebo D + S a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '4005 + ? = 7009',
      ),

      Level(
        index: 155,
        xid: 'esx',
        onGenerate: () => getLevelByIndex(153)!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer jsou vždy 0 - buď řády J+S nebo D + S a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '? + 3004 = 7009',
      ),

      Level(
        index: 156,
        xid: 'fdk',
        onGenerate: () => getLevelByIndex(153)!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer jsou vždy 0 - buď řády J+S nebo D + S a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '4005 + ? = 7009, nebo ? 3004 + ? = 7009',
      ),

      Level(
        index: 157,
        xid: 'csn',
        onGenerate: () {
          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final xh = randomMinMax(1, 8);
          final yh = randomMinMax(1, 9 - xh);

          final x = xt * 1000 + xh * 100;
          final y = yt * 1000 + yh * 100;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '1200 + 1300 = ?',
      ),

      Level(
        index: 158,
        xid: 'gam',
        onGenerate: () => getLevelByIndex(157)!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '1200 + ? = 2500',
      ),

      Level(
        index: 159,
        xid: 'aru',
        onGenerate: () => getLevelByIndex(157)!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '? + 1300 = 2500',
      ),

// //////////////////////////////////////////////////////////////////// Level 160+

      Level(
        index: 160,
        xid: 'ecj',
        onGenerate: () => getLevelByIndex(157)!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v daných řádech je vždy ≤ 9, '
            'celkový součet je < 10000.',
        example: '1200 + ? = 2500, nebo ? + 1300 = 2500',
      ),

      Level(
        index: 165,
        xid: 'apf',
        onGenerate: () {
          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final xh = randomMinMax(1, 9);
          final yh = 10 - xh;

          final x = xt * 1000 + xh * 100;
          final y = yt * 1000 + yh * 100;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je = 10, '
            'celkový součet je < 10000.',
        example: '3300 + 3700 = ?',
      ),

      Level(
        index: 166,
        xid: 'cju',
        onGenerate: () => getLevelByIndex(165)!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je = 10, '
            'celkový součet je < 10000.',
        example: '3300 + ? = 7000',
      ),

      Level(
        index: 167,
        xid: 'byf',
        onGenerate: () => getLevelByIndex(165)!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je = 10, '
            'celkový součet je < 10000.',
        example: '? + 3700 = 7000',
      ),

      Level(
        index: 168,
        xid: 'aam',
        onGenerate: () => getLevelByIndex(165)!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je = 10, '
            'celkový součet je < 10000.',
        example: '3300 + ? = 7000, nebo ? + 3700 = 7000',
      ),

      Level(
        index: 169,
        xid: 'dvn',
        onGenerate: () {
          final xt = randomMinMax(1, 7);
          final yt = randomMinMax(1, 8 - xt);

          final xh = randomMinMax(2, 9);
          final yh = randomMinMax(11 - xh, 9);

          final x = xt * 1000 + xh * 100;
          final y = yt * 1000 + yh * 100;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je > 10, '
            'celkový součet je < 10000.',
        example: '3600 + 3700 = ?',
      ),

// //////////////////////////////////////////////////////////////////// Level 170+

      Level(
        index: 170,
        xid: 'cjm',
        onGenerate: () => getLevelByIndex(169)!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je > 10, '
            'celkový součet je < 10000.',
        example: '3600 + ? = 7300',
      ),

      Level(
        index: 171,
        xid: 'fbf',
        onGenerate: () => getLevelByIndex(169)!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je > 10, '
            'celkový součet je < 10000.',
        example: '? + 3700 = 7300',
      ),

      Level(
        index: 172,
        xid: 'cxf',
        onGenerate: () => getLevelByIndex(169)!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla, '
            'dvě z jejich cifer v řádech jednotek a desítek jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech stovek je > 10, '
            'celkový součet je < 10000.',
        example: '3600 + ? = 7300, nebo ? + 3700 = 7300',
      ),

      Level(
        index: 173,
        xid: 'ete',
        onGenerate: () {
          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final xh = randomMinMax(1, 8);
          final yh = randomMinMax(1, 9 - xh);

          final xd = randomMinMax(1, 8);
          final yd = randomMinMax(1, 9 - xd);

          final xo = randomMinMax(1, 8);
          final yo = randomMinMax(1, 9 - xo);

          final x = xt * 1000 + xh * 100 + xd * 10 + xo * 1;
          final y = yt * 1000 + yh * 100 + yd * 10 + yo * 1;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla a to tak,'
            'že součet čísel sčítanců ve všech řádech je ≤ 9'
            'celkový součet je < 10000.',
        example: '3252 + 3731 = ?',
      ),

      Level(
        index: 174,
        xid: 'ebk',
        onGenerate: () => getLevelByIndex(173)!.onGenerate(),
        masks: ['x+Y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla a to tak, '
            'že součet čísel sčítanců ve všech řádech je ≤ 9'
            'celkový součet je < 10000.',
        example: '3252 + ? = 6983',
      ),

      Level(
        index: 175,
        xid: 'abt',
        onGenerate: () => getLevelByIndex(173)!.onGenerate(),
        masks: ['X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla a to tak, '
            'že součet čísel sčítanců ve všech řádech je ≤ 9'
            'celkový součet je < 10000.',
        example: '? + 3731 = 6983',
      ),

      Level(
        index: 176,
        xid: 'dib',
        onGenerate: () => getLevelByIndex(173)!.onGenerate(),
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 9999],
        description: 'Všechna čísla z úlohy jsou 4 cif. čísla a to tak, '
            'že součet čísel sčítanců ve všech řádech je ≤ 9'
            'celkový součet je < 10000.',
        example: '3252 + ? = 6983, nebo ? + 3731 = 6983',
      ),

      Level(
        index: 177,
        xid: 'akg',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final x = xdt * 10000;
          final y = ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'čtyři z jejich cifer v řádech T, S, D a J jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech desetitisíců je ≤ 9'
            'celkový součet je < 100000.',
        example: '40000 + 20000 = ?',
      ),

      Level(
        index: 178,
        xid: 'acn',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final x = xdt * 10000;
          final y = ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'čtyři z jejich cifer v řádech T, S, D a J jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech desetitisíců je ≤ 9'
            'celkový součet je < 100000.',
        example: '40000 + ? = 60000',
      ),

      Level(
        index: 179,
        xid: 'exc',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final x = xdt * 10000;
          final y = ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['X+y=z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'čtyři z jejich cifer v řádech T, S, D a J jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech desetitisíců je ≤ 9'
            'celkový součet je < 100000.',
        example: '? + 20000 = 60000',
      ),

// //////////////////////////////////////////////////////////////////// Level 180+

      Level(
        index: 180,
        xid: 'ekc',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final x = xdt * 10000;
          final y = ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'čtyři z jejich cifer v řádech T, S, D a J jsou 0 a to tak, '
            'že součet čísel sčítanců v řádech desetitisíců je ≤ 9'
            'celkový součet je < 100000.',
        example: '40000 + ? = 60000, nebo ? + 20000 = 60000',
      ),

      Level(
        index: 181,
        xid: 'bhu',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final yesorno = randomMinMax(0, 1);

          final yh = randomMinMax(1, 9);
          final yd = randomMinMax(1, 9);
          final yo = randomMinMax(1, 9);

          final x = xdt * 10000 + xt * 1000;
          final y =
              ydt * 10000 + yt * 1000 + yesorno * (yh * 100 + yd * 10 + yo * 1);

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'jedno nebo obě čísla mají cifry v řádech S, D a J = 0 a to tak, '
            'že součet čísel sčítanců v řádech tisíců je ≤ 9'
            'celkový součet je < 100000.',
        example: '34000 + 23000 = ?,  nebo 56000 + 12345 = ?',
      ),

      Level(
        index: 182,
        xid: 'fau',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final yesorno = randomMinMax(0, 1);

          final yh = randomMinMax(1, 9);
          final yd = randomMinMax(1, 9);
          final yo = randomMinMax(1, 9);

          final x = xdt * 10000 + xt * 1000;
          final y =
              ydt * 10000 + yt * 1000 + yesorno * (yh * 100 + yd * 10 + yo * 1);

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'jedno nebo obě čísla mají cifry v řádech S, D a J = 0 a to tak, '
            'že součet čísel sčítanců v řádech tisíců je ≤ 9'
            'celkový součet je < 100000.',
        example: '34000 + ? = 57000,  nebo ? + 12345 = 68345',
      ),

      Level(
        index: 183,
        xid: 'fnm',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final xt = randomMinMax(1, 9);
          final yt = 10 - xt;

          final x = xdt * 10000 + xt * 1000;
          final y = ydt * 10000 + yt * 1000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'obě čísla mají cifry v řádech S, D a J = 0 a to tak, '
            'že součet čísel sčítanců v řádech tisíců je = 10'
            'celkový součet je < 100000.',
        example: '34000 + 26000 = ?',
      ),

      Level(
        index: 184,
        xid: 'cio',
        onGenerate: () {
          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final xt = randomMinMax(1, 9);
          final yt = 10 - xt;

          final x = xdt * 10000 + xt * 1000;
          final y = ydt * 10000 + yt * 1000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'obě čísla mají cifry v řádech S, D a J = 0 a to tak, '
            'že součet čísel sčítanců v řádech tisíců je = 10'
            'celkový součet je < 100000.',
        example: '34000 + ? = 60000, nebo ? + 26000 = 60000',
      ),

      Level(
        index: 185,
        xid: 'dnb',
        onGenerate: () {
          final xdt = randomMinMax(1, 7);
          final ydt = randomMinMax(1, 8 - xdt);

          final xt = randomMinMax(2, 9);
          final yt = randomMinMax(11 - xt, 9);

          final x = xdt * 10000 + xt * 1000;
          final y = ydt * 10000 + yt * 1000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'obě čísla mají cifry v řádech S, D a J = 0 a to tak, '
            'že součet čísel sčítanců v řádech tisíců je > 10'
            'celkový součet je < 100000.',
        example: '37000 + 26000 = ?',
      ),

      Level(
        index: 186,
        xid: 'deo',
        onGenerate: () {
          final xdt = randomMinMax(1, 7);
          final ydt = randomMinMax(1, 8 - xdt);

          final xt = randomMinMax(2, 9);
          final yt = randomMinMax(11 - xt, 9);

          final x = xdt * 10000 + xt * 1000;
          final y = ydt * 10000 + yt * 1000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 99999],
        description: 'Všechna čísla z úlohy jsou 5 cif. čísla,'
            'obě čísla mají cifry v řádech S, D a J = 0 a to tak, '
            'že součet čísel sčítanců v řádech tisíců je > 10'
            'celkový součet je < 100000.',
        example: '37000 + ? = 63000, nebo ? + 26000 = 63000',
      ),

      Level(
        index: 187,
        xid: 'cyz',
        onGenerate: () {
          final xht = randomMinMax(1, 8);
          final yht = randomMinMax(1, 9 - xht);

          final x = xht * 100000;
          final y = yht * 100000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 cif. čísla,'
            'je dána cifra pouze v řádu statisíců a to tak, '
            'že součet čísel sčítanců v řádech statisíců je ≤ 9'
            'celkový součet je < 1000000.',
        example: '500000 + 200000 = ?',
      ),

      Level(
        index: 188,
        xid: 'fop',
        onGenerate: () {
          final xht = randomMinMax(1, 8);
          final yht = randomMinMax(1, 9 - xht);

          final x = xht * 100000;
          final y = yht * 100000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 cif. čísla,'
            'je dána cifra pouze v řádu statisíců a to tak, '
            'že součet čísel sčítanců v řádech statisíců je ≤ 9'
            'celkový součet je < 1000000.',
        example: '500000 + ? = 700000, nebo ? + 200000 = 700000',
      ),

      Level(
        index: 189,
        xid: 'fte',
        onGenerate: () {
          final xht = randomMinMax(1, 9);

          final ydt = randomMinMax(1, 9);
          final yt = randomMinMax(1, 9);
          final yh = randomMinMax(1, 9);
          final yd = randomMinMax(1, 9);
          final yo = randomMinMax(1, 9);

          final x = xht * 100000;
          final y = ydt * 10000 + yt * 1000 + yh * 100 + yd * 10 + yo * 1;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 999999],
        description: 'První číslo z úlohy je 6 ciferné číslo dělitelné 100000,'
            'druhé číslo je libovolné 5 ciferné číslo,'
            'celkový součet je < 1000000.',
        example: '400000 + 45765 = ?',
      ),

// //////////////////////////////////////////////////////////////////// Level 190+

      Level(
        index: 190,
        xid: 'evb',
        onGenerate: () {
          final xht = randomMinMax(1, 9);

          final ydt = randomMinMax(1, 9);
          final yt = randomMinMax(1, 9);
          final yh = randomMinMax(1, 9);
          final yd = randomMinMax(1, 9);
          final yo = randomMinMax(1, 9);

          final x = xht * 100000;
          final y = ydt * 10000 + yt * 1000 + yh * 100 + yd * 10 + yo * 1;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 999999],
        description: 'První číslo z úlohy je 6 ciferné číslo dělitelné 100000,'
            'druhé číslo je libovolné 5 ciferné číslo,'
            'celkový součet je < 1000000.',
        example: '400000 + ? = 445765, nebo ? + 45765 = 445765',
      ),

      Level(
        index: 191,
        xid: 'bjw',
        onGenerate: () {
          final xht = randomMinMax(1, 8);
          final yht = randomMinMax(1, 9 - xht);

          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final x = xht * 100000 + xdt * 10000;
          final y = yht * 100000 + ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 ciferná čísla,'
            'jsou dány cifry pouze v řádech ST a DT a to tak,'
            'že součet v jednotlivých řádech ≤ 9'
            'celkový součet je < 1000000.',
        example: '540000 + 230000 = ?',
      ),

      Level(
        index: 192,
        xid: 'die',
        onGenerate: () {
          final xht = randomMinMax(1, 8);
          final yht = randomMinMax(1, 9 - xht);

          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final x = xht * 100000 + xdt * 10000;
          final y = yht * 100000 + ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 ciferná čísla,'
            'jsou dány cifry pouze v řádech ST a DT a to tak,'
            'že součet v jednotlivých řádech ≤ 9'
            'celkový součet je < 1000000.',
        example: '540000 + ? = 770000, nebo ? + 230000 = ?',
      ),

      Level(
        index: 193,
        xid: 'cfw',
        onGenerate: () {
          final xht = randomMinMax(1, 7);
          final yht = randomMinMax(1, 8 - xht);

          final xdt = randomMinMax(2, 9);
          final ydt = randomMinMax(11 - xdt, 9);

          final x = xht * 100000 + xdt * 10000;
          final y = yht * 100000 + ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 ciferná čísla,'
            'jsou dány cifry pouze v řádech ST a DT a to tak,'
            'že součet v řádech desetitisíců je > 10'
            'celkový součet je < 1000000.',
        example: '560000 + 270000 = ?',
      ),

      Level(
        index: 194,
        xid: 'ehf',
        onGenerate: () {
          final xht = randomMinMax(1, 7);
          final yht = randomMinMax(1, 8 - xht);

          final xdt = randomMinMax(2, 9);
          final ydt = randomMinMax(11 - xdt, 9);

          final x = xht * 100000 + xdt * 10000;
          final y = yht * 100000 + ydt * 10000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 ciferná čísla,'
            'jsou dány cifry pouze v řádech ST a DT a to tak,'
            'že součet v řádech desetitisíců je > 10'
            'celkový součet je < 1000000.',
        example: '560000 + ? = 830000, nebo ? + 270000 = 830000',
      ),

      Level(
        index: 195,
        xid: 'cue',
        onGenerate: () {
          final xht = randomMinMax(1, 8);
          final yht = randomMinMax(1, 9 - xht);

          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final x = xht * 100000 + xdt * 10000 + xt * 1000;
          final y = yht * 100000 + ydt * 10000 + yt * 1000;

          return [x, y, x + y];
        },
        masks: ['x+y=Z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 ciferná čísla,'
            'jsou dány cifry pouze v řádech ST, DT a T a to tak,'
            'že součet ve všech řádech je ≤ 9'
            'celkový součet je < 1000000.',
        example: '543000 + 232000 = ?',
      ),

      Level(
        index: 196,
        xid: 'ezc',
        onGenerate: () {
          final xht = randomMinMax(1, 8);
          final yht = randomMinMax(1, 9 - xht);

          final xdt = randomMinMax(1, 8);
          final ydt = randomMinMax(1, 9 - xdt);

          final xt = randomMinMax(1, 8);
          final yt = randomMinMax(1, 9 - xt);

          final x = xht * 100000 + xdt * 10000 + xt * 1000;
          final y = yht * 100000 + ydt * 10000 + yt * 1000;

          return [x, y, x + y];
        },
        masks: ['x+Y=z', 'X+y=z'],
        valueRange: [0, 999999],
        description: 'Všechna čísla z úlohy jsou 6 ciferná čísla,'
            'jsou dány cifry pouze v řádech ST, DT a T a to tak,'
            'že součet ve všech řádech je ≤ 9'
            'celkový součet je < 1000000.',
        example: '543000 + ? = 775000, nebo ? + 232000 = 775000',
      ),
    ];
  } //

}
