import 'dart:math';

abstract class ILevelTree {
  static Random r = Random();

  static int random(int maximum) {
    if (maximum == 0) return 0;
    return r.nextInt(maximum + 1);
  }

  static int randomMinMax(int min, int max) =>
      max <= min ? min : r.nextInt(max - min + 1) + min;
}
