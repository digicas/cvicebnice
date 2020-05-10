// Encapsulation / namespacing of the tasks code
//
// Used by the [TaskRegister] collection
export 'screen.dart';
export 'leveltree.dart';
export 'level.dart';

import 'leveltree.dart';

/// Returns the number of implemented levels
int levelsCount() {
  var levelTree = LevelTree();
  return levelTree.levels.length;
}

/// Gets Information whether particular level with index is implemented
bool isLevelImplemented(int index) {
  print("Checking additions for level: $index");
  var levelTree = LevelTree();
  return levelTree.getLevelByIndex(index) != null;
}
