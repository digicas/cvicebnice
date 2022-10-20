import 'dart:math';

abstract class ILevel {
  const ILevel({required this.index, required this.xid});

  final String xid;
  final int index;

  void generate();

  void regenerate() => generate();

  @override
  String toString();
}

abstract class ILevelTree {
  static Random r = Random();

  static int random(int maximum) {
    if (maximum == 0) return 0;
    return r.nextInt(maximum + 1);
  }

  static int randomMinMax(int min, int max) =>
      max <= min ? min : r.nextInt(max - min + 1) + min;
}
