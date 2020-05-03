import 'dart:math';

/// Common blueprint for the Level implementations
///
/// Should be extended (not implemented) in order to inherit members
///
///
/// ```
///
/// ```
abstract class LevelBlueprint {
  /// index of the level within LevelTree
  final int index;

  /// initializes index for subclasses
  const LevelBlueprint({this.index});

  /// Initial generation of the task and solution
  ///
  ///
  void generate();

  /// New generation of the level task and solution
  ///
  /// Typically just referenced to [generate()]
  void regenerate() => generate();

  /// Returns a string representation of this object.
  @override
  String toString();
}


/// Common blueprint for the LevelTree implementations
///
/// Some utility methods are defined and implemented below
/// Following members must be implemented as static, but cannot be defined here as
/// static methods are not inherited in Dart and their return type is
/// LevelBlueprint's descendant:
/// ```
///   static Level getLevelByIndex(int levelIndex) {
///    return LevelTree.levels
///        .singleWhere((level) => level.index == levelIndex, orElse: () => null);
///  }
///
/// // Definitions of levels
/// static final List<Level> levels
/// ```
abstract class LevelTreeBlueprint {

  /// Random generator initialization
  ///
  /// Random numbers are often used for level definition callbacks.
  /// In order to use that the static methods are implemented below.
  /// However static methods cannot be inherited in Dart, therefore
  /// inherited LevelTree must implement own static methods
  static Random rnd = Random();

  /// Generates int number 0..maximum : inclusive
  ///
  /// ```
  /// int k = random(1);
  /// ```
  /// Static implementation below
  /// Inherited LevelTree must implement own static method in order to use it
  /// within Level definition constructor callbacks
  /// ```
  /// static Function random = LevelTreeBlueprint.random;
  /// ```
  /// or
  /// ```
  /// static int random(int maximum) => LevelTreeBlueprint.random(maximum);
  /// ```
  static int random(int maximum) {
    if (maximum == 0) return 0;
    return rnd.nextInt(maximum + 1);
  }

  /// Generates int number minimum..maximum : inclusive
  ///
  /// If max < or = min returns min
  /// ```
  /// int x = randomMinMax(1, 9);
  /// ```
  /// Inherited LevelTree must implement own static method in order to use it
  /// within Level definition constructor callbacks
  /// ```
  /// static Function randomMinMax = LevelTreeBlueprint.randomMinMax;
  /// ```
  /// or
  /// ```
  /// static int randomMinMax(int minimum, int maximum) =>
  ///   LevelTreeBlueprint.randomMinMax(minimum, maximum);
  /// ```
  static int randomMinMax(int minimum, int maximum) {
    if (maximum <= minimum) return minimum;
    return LevelTreeBlueprint.rnd.nextInt(maximum - minimum + 1) + minimum;
  }


}
