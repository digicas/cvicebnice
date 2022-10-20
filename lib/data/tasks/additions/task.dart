// Encapsulation / namespacing of the tasks code
//
// Used by the [TaskRegister] collection
// Serves as the unifying proxy to methods calls
// Ideally implements at least:
//    isLevelImplemented
//    onOpenTaskScreen
//    onSchoolClassToLevelIndex

import 'dart:developer';

import 'package:cvicebnice/constants.dart';
import 'package:cvicebnice/data/tasks/additions/level_tree.dart';
import 'package:cvicebnice/data/tasks/additions/screen.dart';
import 'package:flutter/material.dart';

export 'preview.dart'; // for getLevelPreview()

/// Taken from Tasks Type register for info, what is implemented here
//TasksRegisterItem(
//xid: "cad",
//imageAssetName: "assets/menu_additions.png",
//label: "Sčítání",
//isLevelImplemented: additions.isLevelImplemented,
//onOpenTaskScreen: additions.onOpenTaskScreen,
//onSchoolClassToLevelIndex: additions.onSchoolClassToLevelIndex,
//getLevelDescription: additions.getLevelDescription,
//getLevelSuitability: additions.getLevelSuitability,
//getLevelXid: additions.getLevelXid,
//getLevelIndexFromXid: additions.getLevelIndexFromXid,
//onLevelsCount: additions.levelsCount,
//getLevelPreview: additions.getLevelPreview,
//),

/// Returns the addition's TaskScreen Widget
Widget onOpenTaskScreen(int levelIndex) => TaskScreen(
      selectedLevelIndex: levelIndex,
    );

/// Returns the number of implemented levels
int levelsCount() => LevelTree().levels.length;

int get lastIndex => LevelTree().levels.last.index;

/// Gets Information whether particular level with index is implemented
bool isLevelImplemented(int index) {
  log('Checking if additions level is implemented: $index');
  return LevelTree().getLevelByIndex(index) != null;
}

int onSchoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  return LevelTree.schoolClassToLevelIndex(schoolYear, schoolMonth);
}

String getLevelDescription(int index) {
  final level = LevelTree().getLevelByIndex(index);
  var text = '';
  // Example is not needed due to preview rendered/
  text += '\n\nPříklad: ';
  text += level?.example ?? 'Příklad nám chybí :(';
  return text;
}

String getLevelXid(int index) {
  final levelTree = LevelTree();
  return levelTree.getLevelByIndex(index)!.xid;
}

/// Gets the levelIndex in [LevelTree] based on whole xid "abcghi"
///
/// Returns -1 if levelIndex is not found.
int getLevelIndexFromXid(String wholeXid) {
  final levelTree = LevelTree();
  return levelTree.getLevelIndexFromXid(wholeXid);
}

/// Generates the string representation of the suitable school classes / months
String getLevelSuitability(int levelIndex) {
  List<List<int>> schoolYearMonth;
  var text = '';
  schoolYearMonth = LevelTree.getMinimumSchoolClassAndMonth(levelIndex);

  var monthText = kMonths[schoolYearMonth[0][1]];
  text += 'Vhodné od ${schoolYearMonth[0][0]}. třídy ($monthText)';

  // check whether we have additional occurrence of the level in the year
  if (schoolYearMonth.length > 1) {
    monthText = kMonths[schoolYearMonth[1][1]];
    text += ' a zopakovat od ${schoolYearMonth[1][0]}. třídy ($monthText)';
  }
  return text;
}
