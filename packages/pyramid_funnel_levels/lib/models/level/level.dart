import 'dart:math';

import 'package:pyramid_funnel_levels/models/pyramid_mask.dart';

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
}
