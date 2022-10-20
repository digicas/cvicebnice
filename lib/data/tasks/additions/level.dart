import 'dart:math';

import 'package:cvicebnice/data/tasks/core/level.dart';

class Level extends ILevel {
  Level({
    required super.index,
    required super.xid,
    required this.onGenerate,
    this.onCheck,
    required this.masks,
    required this.valueRange,
    required this.description,
    required this.example,
  });

  Level clone() {
    return Level(
      index: index,
      xid: xid,
      onGenerate: onGenerate,
      onCheck: onCheck,
      masks: masks,
      valueRange: valueRange,
      description: description,
      example: example,
    );
  }

  List<int> Function() onGenerate;
  bool Function(List<int> generated, List<int> filled)? onCheck;

  List<String> masks;

  List<int> valueRange;
  String description;
  String example;
  List<int>? solution;

  int selectedQuestionsMaskID = 0;
  String get selectedQuestionMask => masks[selectedQuestionsMaskID];

  static Random r = Random();

  @override
  void generate() {
    solution = onGenerate();
    selectedQuestionsMaskID = r.nextInt(masks.length);
  }

  static bool checkSubmission(
    List<int> generated,
    List<int?> filled,
    String mask,
  ) {
    /// In case of empty submission - we cannot calculate with null
    if (filled[0] == null) return false;

    if (['x+y=Z'].contains(mask)) {
      return generated[0] + generated[1] == filled[0];
    }

    if (['x+Y=z'].contains(mask)) {
      return generated[0] + filled[0]! == generated[2];
    }

    if (['X+y=z'].contains(mask)) {
      return filled[0]! + generated[1] == generated[2];
    }

    if (['x+y+w=ZZ'].contains(mask)) {
      return generated[0] + generated[1] + generated[2] == filled[0]!;
    }

    if (['100=k+X'].contains(mask)) {
      return 100 == generated[0] + filled[0]!;
    }

    assert(false, 'Mask $mask not implemented');

    return false;
  }

  @override
  String toString() =>
      'level: $index - $xid - $solution - ${masks[selectedQuestionsMaskID]}';
}
