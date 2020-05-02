///
/// Common contract for the Level implementations
///
/// Should be extended (not implemented) to inherit members
///
///
/// ```
///
/// ```
abstract class LevelContract {
  /// index of the level within LevelTree
  final int index;

  /// initializes index for subclasses
  const LevelContract({this.index});

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

