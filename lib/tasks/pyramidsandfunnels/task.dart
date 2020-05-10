// Encapsulation / namespacing of the tasks code
//
// Serves as the unifying proxy to methods calls
export 'screen.dart';
export 'triangle_levels.dart';

import 'dart:math';

import 'package:flutter/material.dart';

import 'screen.dart';
import 'triangle_levels.dart';

/// Returns the number of implemented levels
int levelsCount() {
  return LevelTree.levels.length;
}

/// Returns the number of defined masks
int masksCount() {
  return LevelTree.levels.fold(0, (p, e) => p + e.masksAmount);
}

/// Estimation on the number of questions (i.e. all random combinations)
int questionsCount() {
  return LevelTree.levels.fold(
      0,
      (p, e) =>
          p +
          e.masksAmount *
              (pow((e.maxTotal ~/ (e.solutionRows - 1)), e.solutionRows)));
}

/// Gets Information whether particular level with index is implemented
bool isLevelImplemented(int index) {
  print("checking $index");
  return LevelTree.getLevelByLevelIndex(index) != null;
}

/// Gets the task screen for Pyramids
Widget openPyramidsTaskScreen(int selectedLevelIndex) {
  return TaskScreen(
      level: LevelTree.getLevelByLevelIndex(selectedLevelIndex),
      taskType: TriangleTaskType.Pyramid);
}

/// Gets the task screen for Funnels
Widget openFunnelsTaskScreen(int selectedLevelIndex) {
  return TaskScreen(
      level: LevelTree.getLevelByLevelIndex(selectedLevelIndex),
      taskType: TriangleTaskType.Funnel);
}

/// Obtain the level index based on the school year and month
int schoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  return LevelTree.schoolClassToLevelIndex(
      schoolYear.toInt(), schoolMonth.toInt());
}
