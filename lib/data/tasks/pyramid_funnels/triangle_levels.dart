// ignore_for_file: use_string_buffers, avoid_multiple_declarations_per_line

import 'dart:math';

import 'package:flutter/material.dart';

/// Placeholder for submission data
///
class SubmissionController extends ChangeNotifier {
  SubmissionController({required this.level}) {
    cells = List<int?>.generate(
      level._solution.length,
      (_) => null,
    );

    initiateForLevel(level);

    isSolved = false;
    isFilled = false;
  }

  /// data placeholder for up to 10 cells indexed 0.. solution length
  List<int?> cells = [];

  /// whether the submission is correct
  bool isSolved = false;

  /// whether all to be filled cells have some value
  bool isFilled = false;

  /// related level, which must be generated up front
  final Level level;

  /// called when any of the text cells is updated
  /// notifies listeners
  void onChanged() {
    isSolved = checkSolution();
    isFilled = checkIfAllFilled();
    notifyListeners();
//    _printLatestValue();
  }

//  _printLatestValue() {
//    log("Submission: ${toString()}");
//  }

  /// empties the submission but does NOT initiates with the predefined
  /// (visible) values for those cells where mask allows visibility to user
  void eraseSubmission() {
    for (final cell in cells) {
      cells[cells.indexOf(cell)] = null;
    }
  }

  /// apply level data to submission
  /// level solution must be generated before this call!
  void initiateForLevel(Level level) {
    for (var i = 0; i < level.solution.length; i++) {
      cells[i] = level.solutionMask.mask[i] ? level.solution[i] : null;
    }
  }

  @override
  String toString() {
    return cells.map((cell) => '$cell').join(', ');
  }

  /// checks whether the submitted solution is equal to generated solution
  bool checkSolution() {
    var done = true;
    for (var i = 0; i < level.solution.length; i++) {
      if (cells[i] != level.solution[i]) done = false;
    }
    return done;
  }

  /// checks whether all to be submitted cells are non empty
  bool checkIfAllFilled() {
    var filled = true;
    for (var i = 0; i < level.solution.length; i++) {
      // consider only editable cells
      if (level.solutionMask.mask[i] == false) {
        // if some editable cell is empty
        if (cells[i] == null) {
          filled = false;
        }
      }
    }
    return filled;
  }
}

//////////////////////////////////////////////// Level generator //////////////////////////////

class Level {
//  List<int> _task; // task has applied mask - in fact not used - only solution is used

  Level({
    required this.levelIndex,
    required this.maxTotal,
    required List<List<int>> masks,
  }) {
//    this._masks = masks;
    _masks = masks.map(PyramidMask.new).toList();
//    generate();
  }
  late int levelIndex;
  late int maxTotal;
  late List<PyramidMask> _masks;

  static Random rng = Random();
  int _selectedTaskMask = 0;
  late List<int> _solution;

//
// important for rendering
//
  List<int> get solution => _solution;

  PyramidMask get solutionMask => _masks[_selectedTaskMask];

//
//  returns number of rows the selected solution  has
//
  int get solutionRows => solutionMask.rows;

  int get masksAmount => _masks.length;

  String allMasksToString() {
    return _masks.map((mask) => mask.toPrettyString()).join(', ');
  }

  ///
  ///  gets the amount of rows of the highest pyramid
  ///
  int get maxRows {
    return _masks
        .map((mask) => mask.rows)
        .reduce((curr, next) => curr > next ? curr : next);
  }

  ///
  ///  generates number 0..maximum : inclusive
  ///
  static int random(int maximum) {
    if (maximum == 0) return 0;
    return rng.nextInt(maximum + 1);
  }

  void generate() {
    _selectedTaskMask = rng.nextInt(_masks.length);

//    Regenerate, if conditions are not fulfilled
//    conditions: base numbers contain max one 0
    bool regenerationNeeded;

    do {
      regenerationNeeded = false;

// funnel:
// a    b       c     d
//  a+b    b+c    c+d
//    a+2b+c  b+2c+d
//      a+3b+3c+d
//
      switch (solutionRows) {
        case 2:
          {
            _solution = [];
            _solution
              ..add(random(maxTotal - 1) + 1) // a+b
              ..add(random(_solution[0])) // a
              ..add(_solution[0] - _solution[1]); // b
            regenerationNeeded = _solution[1] + _solution[2] == 0;
          }
          break;
        case 3:
          {
            _solution = [];
            final b = random(maxTotal) ~/ 2;
            final c = random(maxTotal - (2 * b));
            final a = random(maxTotal - (2 * b + c));
            _solution
              ..add(a + 2 * b + c)
              ..add(a + b)
              ..add(b + c)
              ..addAll([a, b, c]);
            regenerationNeeded = [a, b, c].where((it) => it == 0).length > 1;
//            log("$regenerationNeeded $_solution");
          }
          break;
        case 4:
          {
            _solution = [];
            final b = random(maxTotal) ~/ 3;
            final c = random(maxTotal - (3 * b)) ~/ 3;
            final a = random(maxTotal - (3 * b + 3 * c));
            final d = random(maxTotal - (a + 3 * b + 3 * c));
            _solution
              ..add(a + 3 * b + 3 * c + d)
              ..add(a + 2 * b + c)
              ..add(b + 2 * c + d)
              ..add(a + b)
              ..add(b + c)
              ..add(c + d)
              ..addAll([a, b, c, d]);
            regenerationNeeded = [a, b, c, d].where((it) => it == 0).length > 1;
          }
          break;
      }
    } while (regenerationNeeded); // QA on generated numbers
//    print (_solution);
  }

  void regenerate() => generate();

  @override
  String toString() =>
      '''$levelIndex: max: $maxTotal $_solution ${_masks[_selectedTaskMask].toPrettyString()} $solutionRows''';
} // Level

///
/// Mask defining the to be edited cells within task/solution
///
class PyramidMask {
  PyramidMask(this._mask);

  final List<int> _mask;

  int get length => _mask.length;

  List<bool> get mask => _mask.map((v) => v == 1).toList();

  ///
  /// get the amount of rows given the length of the pyramid
  ///
  int get rows {
    final length = _mask.length;
    assert(length >= 0 && length < 11, '');
    final map = [0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4];
    return map[length];
  }

  static String _toSpacedString(List<int> mask) {
    var out = '';
    for (var i = 0, j = 1; i + j <= mask.length; i = i + j, j++) {
      for (var cx = i; cx < i + j; cx++) {
        out += '${mask[cx]}';
      }
      out += ' ';
    }
    return out.trim();
  }

  String toPrettyString() {
    switch (_mask.length) {
      case 0:
        return '[]';
      case 1:
        return '[${_mask[0]}]';
      case 3:
        return '[${_toSpacedString(_mask)}]';
      case 6:
        return '[${_toSpacedString(_mask)}]';
      case 10:
        return '[${_toSpacedString(_mask)}]';
      default:
        throw Exception('invalid mask');
    }
  }
}

///
/// ///////////////////////// Tree of levels (incl. definitions) //////////////////////////////
///
class LevelTree {
  static Level? getLevelByLevelIndex(int levelIndex) {
    return LevelTree.levels
        .singleWhere((level) => level.levelIndex == levelIndex);
  }

  /// returns more difficult level if there is any
  static Level getMoreDifficultLevel(Level level) {
    Level? newLevel;
    var newLevelIndex = level.levelIndex;

    /// avoid not implemented levels
    while (newLevel == null) {
      newLevelIndex++;

      /// max level -> return the same level
      if (level.levelIndex == levels.last.levelIndex) return level;
      newLevel = getLevelByLevelIndex(newLevelIndex);
    }
    return newLevel;

//    return getLevelByLevelIndex(level.levelIndex + 1);
  }

  /// returns less difficult level if there is any
  static Level getLessDifficultLevel(Level level) {
    var newLevelIndex = level.levelIndex;
    Level? newLevel;

    /// avoid not implemented levels
    while (newLevel == null) {
      newLevelIndex--;

      /// min level -> return the same level
      if (newLevelIndex == 0) return level;
      newLevel = getLevelByLevelIndex(newLevelIndex);
    }
    return newLevel;
  }

  /// returns levelIndex number based
  static int schoolClassToLevelIndex(int schoolClass, int monthInSchool) {
    assert(schoolClass > -1, ''); // 0 schoolClass is tutorial
    assert(monthInSchool > -1 && monthInSchool < 10, ''); // 0..Sept, 9..June
    // highest defined schoolClass
    return schoolClassToLevelMap[schoolClass > 5 ? 5 : schoolClass]
        [monthInSchool];
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

////////////////////////////////////////////////// lookups to find levels

// each row is the schoolClass (0-5)
// each column is the schoolMonth (0-9)
  static final List<List<int>> schoolClassToLevelMap = [
    //9  10  11  12  01  02  03  04  05  06 -- months in the school year
    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00], // 0 class => tutorial
    [02, 02, 02, 02, 08, 12, 16, 20, 24, 24], // 1st class
    [21, 30, 39, 39, 48, 48, 57, 57, 61, 61], // 2nd
    [60, 60, 60, 62, 64, 64, 64, 64, 67, 67], // 3rd
    [66, 66, 66, 72, 72, 72, 78, 78, 85, 85], // 4th
    [84, 84, 84, 90, 90, 90, 96, 96, 96, 96], // 5th
  ];

  /// level definitions

  static final List<Level> levels = [
    Level(
      levelIndex: 2,
      maxTotal: 10,
      masks: [
        [0, 1, 1],
      ],
    ),
    Level(
      levelIndex: 3,
      maxTotal: 10,
      masks: [
        [1, 0, 1],
        [1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 4,
      maxTotal: 10,
      masks: [
        [0, 0, 0, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 5,
      maxTotal: 10,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 6,
      maxTotal: 10,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 7,
      maxTotal: 10,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0]
      ],
    ),
    Level(
      levelIndex: 8,
      maxTotal: 12,
      masks: [
        [0, 0, 0, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 9,
      maxTotal: 12,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),
///////////// 10+
    Level(
      levelIndex: 10,
      maxTotal: 12,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 11,
      maxTotal: 12,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 12,
      maxTotal: 15,
      masks: [
        [0, 0, 0, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 13,
      maxTotal: 15,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 14,
      maxTotal: 15,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 15,
      maxTotal: 15,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),

    Level(
      levelIndex: 16,
      maxTotal: 18,
      masks: [
        [0, 0, 0, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 17,
      maxTotal: 18,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0]
      ],
    ),
    Level(
      levelIndex: 18,
      maxTotal: 18,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 19,
      maxTotal: 18,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),

///////////// 20+
    Level(
      levelIndex: 20,
      maxTotal: 20,
      masks: [
        [0, 0, 0, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 21,
      maxTotal: 20,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0]
      ],
    ),

    Level(
      levelIndex: 22,
      maxTotal: 20,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 23,
      maxTotal: 20,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),

    Level(
      levelIndex: 24,
      maxTotal: 20,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 25,
      maxTotal: 20,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 26,
      maxTotal: 20,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 27,
      maxTotal: 20,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 28,
      maxTotal: 20,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 29,
      maxTotal: 20,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),

///////////// 30+

    Level(
      levelIndex: 30,
      maxTotal: 30,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 31,
      maxTotal: 30,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 32,
      maxTotal: 30,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 33,
      maxTotal: 30,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 34,
      maxTotal: 30,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 35,
      maxTotal: 30,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 36,
      maxTotal: 30,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 37,
      maxTotal: 30,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 38,
      maxTotal: 30,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),

    Level(
      levelIndex: 39,
      maxTotal: 40,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),

///////////// 40+
    Level(
      levelIndex: 40,
      maxTotal: 40,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 41,
      maxTotal: 40,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 42,
      maxTotal: 40,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 43,
      maxTotal: 40,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 44,
      maxTotal: 40,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 45,
      maxTotal: 40,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 46,
      maxTotal: 40,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 47,
      maxTotal: 40,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 48,
      maxTotal: 60,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 49,
      maxTotal: 60,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),

///////////// 50+
    Level(
      levelIndex: 50,
      maxTotal: 60,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 51,
      maxTotal: 60,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 52,
      maxTotal: 60,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 53,
      maxTotal: 60,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 54,
      maxTotal: 60,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 55,
      maxTotal: 60,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 56,
      maxTotal: 60,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 57,
      maxTotal: 100,
      masks: [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 1, 1, 0, 1],
        [0, 1, 0, 0, 1, 1],
        [0, 0, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 58,
      maxTotal: 100,
      masks: [
        [0, 1, 1, 0, 0, 1],
        [0, 1, 1, 0, 1, 0],
        [0, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 59,
      maxTotal: 100,
      masks: [
        [1, 1, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 1, 0, 0],
      ],
    ),

///////////// 60+ done
    Level(
      levelIndex: 60,
      maxTotal: 100,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
      ],
    ),
    Level(
      levelIndex: 61,
      maxTotal: 100,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 62,
      maxTotal: 100,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 63,
      maxTotal: 100,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 64,
      maxTotal: 100,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 65,
      maxTotal: 100,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 66,
      maxTotal: 200,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 67,
      maxTotal: 200,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 68,
      maxTotal: 200,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 69,
      maxTotal: 200,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),

///////////// 70+
    Level(
      levelIndex: 70,
      maxTotal: 200,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 71,
      maxTotal: 200,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 72,
      maxTotal: 350,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 73,
      maxTotal: 350,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 74,
      maxTotal: 350,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 75,
      maxTotal: 350,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 76,
      maxTotal: 350,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 77,
      maxTotal: 350,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 78,
      maxTotal: 500,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 79,
      maxTotal: 500,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),

///////////// 80+
    Level(
      levelIndex: 80,
      maxTotal: 500,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 81,
      maxTotal: 500,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 82,
      maxTotal: 500,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 83,
      maxTotal: 500,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 84,
      maxTotal: 650,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 85,
      maxTotal: 650,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 86,
      maxTotal: 650,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 87,
      maxTotal: 650,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 88,
      maxTotal: 650,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 89,
      maxTotal: 650,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),

///////////// 90+
    Level(
      levelIndex: 90,
      maxTotal: 800,
      masks: [
        [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      ],
    ),
    Level(
      levelIndex: 91,
      maxTotal: 800,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 92,
      maxTotal: 800,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 93,
      maxTotal: 800,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 94,
      maxTotal: 800,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 95,
      maxTotal: 800,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
    Level(
      levelIndex: 96,
      maxTotal: 1000,
      masks: [
        [0, 0, 0, 0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
      ],
    ),
    Level(
      levelIndex: 97,
      maxTotal: 1000,
      masks: [
        [0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1, 0, 1, 0, 1],
        [0, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      ],
    ),
    Level(
      levelIndex: 98,
      maxTotal: 1000,
      masks: [
        [0, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 0, 1, 0, 0, 0, 0, 1, 1],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 0],
      ],
    ),
    Level(
      levelIndex: 99,
      maxTotal: 1000,
      masks: [
        [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
      ],
    ),

///////////// 100+
    Level(
      levelIndex: 100,
      maxTotal: 1000,
      masks: [
        [1, 1, 0, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 0, 1, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 1, 0],
        [1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 1, 0, 0],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 1, 0],
      ],
    ),
  ];
} // LevelTree
