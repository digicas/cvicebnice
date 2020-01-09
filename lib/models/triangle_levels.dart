import 'dart:math';

class LevelTree{

}


final List<Level> levels = [
  Level(levelIndex: 2, maxTotal: 10, masks: [
    [0, 1, 1],
  ]),
  Level(levelIndex: 3, maxTotal: 10, masks: [
    [1, 0, 1],
    [1, 1, 0],
  ]),
  Level(levelIndex: 4, maxTotal: 10, masks: [
    [0, 0, 0, 1, 1, 1],
  ]),
  Level(levelIndex: 5, maxTotal: 10, masks: [
    [0, 1, 0, 1, 0, 1],
    [0, 0, 1, 1, 0, 1],
    [0, 1, 0, 0, 1, 1],
    [0, 0, 1, 1, 1, 0],
  ]),
  Level(levelIndex: 6, maxTotal: 10, masks: [
    [0, 1, 1, 0, 0, 1],
    [0, 1, 1, 0, 1, 0],
    [0, 1, 1, 1, 0, 0],
    [1, 0, 0, 0, 1, 1],
    [1, 0, 0, 1, 1, 0],
  ]),
  Level(levelIndex: 7, maxTotal: 10, masks: [
    [1, 1, 0, 1, 0, 0],
    [1, 1, 0, 0, 1, 0],
    [1, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 0, 1],
    [1, 0, 1, 0, 1, 0],
    [1, 0, 1, 1, 0, 0]
  ]),
  Level(levelIndex: 8, maxTotal: 12, masks: [
    [0, 0, 0, 1, 1, 1],
  ]),
  Level(levelIndex: 9, maxTotal: 12, masks: [
    [0, 1, 0, 1, 0, 1], [0, 0, 1, 1, 0, 1], [0, 1, 0, 0, 1, 1], [0, 0, 1, 1, 1, 0],
  ]),
  Level(levelIndex: 10, maxTotal: 12, masks: [
    [0, 1, 1, 0, 0, 1], [0, 1, 1, 0, 1, 0], [0, 1, 1, 1, 0, 0], [1, 0, 0, 0, 1, 1], [1, 0, 0, 1, 1, 0],
  ]),
  Level(levelIndex: 11, maxTotal: 12, masks: [
    [1, 1, 0, 1, 0, 0], [1, 1, 0, 0, 1, 0], [1, 1, 0, 0, 0, 1], [1, 0, 1, 0, 0, 1], [1, 0, 1, 0, 1, 0], [1, 0, 1, 1, 0, 0],
  ]),
  Level(levelIndex: 12, maxTotal: 15, masks: [
    [0, 0, 0, 1, 1, 1],
  ]),



  Level(levelIndex: 24, maxTotal: 20, masks: [
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
  ]),
  Level(levelIndex: 30, maxTotal: 30, masks: [
    [0, 1, 0, 1, 0, 1],
    [0, 0, 1, 1, 0, 1],
    [0, 1, 0, 0, 1, 1],
    [0, 0, 1, 1, 1, 0],
  ]),
  Level(levelIndex: 99, maxTotal: 1000, masks: [
    [0, 1, 1, 0, 0, 0, 1, 1, 0, 0],
    [0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
    [0, 1, 1, 0, 0, 0, 0, 1, 1, 0],
  ]),
];

// each row is the schoolClass (0-5)
// each column is the schoolMonth (0-9)
List<List<int>> schoolClassToLevelMap = [
// 09  10  11  12  01  02  03  04  05  06 -- months in the school year
  [00, 00, 00, 00, 00, 00, 00, 00, 00, 00], // 0 class => tutorial
  [02, 02, 02, 02, 08, 12, 16, 20, 24, 24], // 1st class
  [21, 30, 39, 39, 48, 48, 57, 57, 61, 61], // 2nd
  [60, 60, 60, 62, 64, 64, 64, 64, 67, 67], // 3rd
  [66, 66, 66, 72, 72, 72, 78, 78, 85, 85], // 4th
  [84, 84, 84, 90, 90, 90, 96, 96, 96, 96], // 5th
];

class Level {
  int levelIndex;
  int maxTotal;
  List<PyramidMask> _masks;

  static Random rng = Random();
  int _selectedTaskMask = 0;
  List<int> _solution;
//  List<int> _task; // task has applied mask - in fact not used - only solution is used

  Level({this.levelIndex, this.maxTotal, List<List<int>> masks}) {
//    this._masks = masks;
    _masks = masks.map((listMask) => PyramidMask(listMask)).toList();
    generate();
  }

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
    return _masks.map((mask) => mask.toPrettyString()).join(", ");
  }

//
//  gets the amount of rows of the highest pyramid
//
  int get maxRows {
    return _masks
        .map((mask) => mask.rows)
        .reduce((curr, next) => curr > next ? curr : next);
  }

  static int whichEnterLevel(int czSchoolClass, int monthOfSchoolYear) {
    return 0;
  }

//
//  generates number 0..maximum : inclusive
//
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
            _solution.add(random(maxTotal - 1) + 1); // a+b
            _solution.add(random(_solution[0])); // a
            _solution.add(_solution[0] - _solution[1]); // b
            regenerationNeeded = (_solution[1]+_solution[2] == 0);
          }
          break;
        case 3:
          {
            _solution = [];
            var b = random(maxTotal) ~/ 2;
            var c = random(maxTotal - (2 * b));
            var a = random(maxTotal - (2 * b + c));
            _solution.add(a + 2 * b + c);
            _solution.add(a + b);
            _solution.add(b + c);
            _solution.addAll([a, b, c]);
            regenerationNeeded = [a, b, c].where((it) => it == 0).length > 1;
//            print("$regenerationNeeded $_solution");
          }
          break;
        case 4:
          {
            _solution = [];
            var b = random(maxTotal) ~/ 3;
            var c = random(maxTotal - (3 * b)) ~/ 3;
            var a = random(maxTotal - (3 * b + 3 * c));
            var d = random(maxTotal - (a + 3 * b + 3 * c));
            _solution.add(a + 3 * b + 3 * c + d);
            _solution.add(a + 2 * b + c);
            _solution.add(b + 2 * c + d);
            _solution.add(a + b);
            _solution.add(b + c);
            _solution.add(c + d);
            _solution.addAll([a, b, c, d]);
            regenerationNeeded = [a, b, c, d].where((it) => it == 0).length > 1;
          }
          break;
      }
    } while (regenerationNeeded); // QA on generated numbers
//    print (_solution);
  }

  void regenerate() => generate();

  String levelToSchoolClass() {
    // issue - 2 classes for 1 level
    return "XXXX";
  }

  static int schoolClassToLevel(int schoolClass, int monthInSchool) {
    assert(schoolClass > -1); // 0 schoolClass is tutorial
    assert(monthInSchool > -1 && monthInSchool < 10); // 0..Sept, 9..June
    schoolClass = (schoolClass > 5) ? 5 : schoolClass; // highest defined schoolClass

    return schoolClassToLevelMap[schoolClass][monthInSchool];
  }


  @override
  String toString() =>
      "max: $maxTotal $_solution ${_masks[_selectedTaskMask].toPrettyString()} $solutionRows";
} // Level

class PyramidMask {
  PyramidMask(this._mask);

  final List<int> _mask;

  int get length => _mask.length;

  List<bool> get mask => _mask.map((v) => v == 1 ? true : false).toList();

//
// get the amount of rows given the length of the pyramid
//
  int get rows {
    int length = _mask.length;
    assert(length >= 0 && length < 11);
    var _map = [0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4];
    return _map[length];
  }

  static String _toSpacedString(_mask) {
    String out = "";
    for (int i = 0, j = 1; i + j <= _mask.length; i = i + j, j++) {
      for (int cx = i; cx < i + j; cx++) {
        out = out + _mask[cx].toString();
      }
      out += " ";
    }
    return out.trim();
  }

  String toPrettyString() {
    switch (_mask.length) {
      case 0:
        return "[]";
      case 1:
        return "[${_mask[0]}]";
      case 3:
        return "[${_toSpacedString(_mask)}]";
      case 6:
        return "[${_toSpacedString(_mask)}]";
      case 10:
        return "[${_toSpacedString(_mask)}]";
      default:
        throw Exception("invalid mask");
    }
  }
}
