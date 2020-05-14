// Encapsulation / namespacing of the tasks code
//
// Used by the [TaskRegister] collection
// Serves as the unifying proxy to methods calls
// Ideally implements at least:
//    isLevelImplemented
//    onOpenTaskScreen
//    onSchoolClassToLevelIndex

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

int onSchoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  return LevelTree.schoolClassToLevelIndex(schoolYear, schoolMonth);
//
//
//  print("SchoolYear/schoolMonth proxy not implemented.");
//  return 0;
}

String getLevelDescription(int index) {
  var levelTree = LevelTree();
  var level = levelTree.getLevelByIndex(index);
  if (level == null) return "";
  String text = "";
  text += level.description ?? "Popis ješte není :(";
  text += "\n\nPříklad: ";
  text += level.example ?? "Příklad nám chybí :(";
  return text;
}

String getLevelXid(int index) {
  var levelTree = LevelTree();
  var level = levelTree.getLevelByIndex(index);
  if (level == null) return "!!!";
  if (level.xid == null) return "???";
  return level.xid;
}