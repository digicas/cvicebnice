// Encapsulation / namespacing of the tasks code
//
// Serves as the unifying proxy to methods calls
//export 'screen.dart';
//export 'triangle_levels.dart';

import 'dart:developer' as dev;
import 'dart:math';

import 'package:cvicebnice/data/tasks/pyramid_funnels/screen.dart';
import 'package:cvicebnice/data/tasks/pyramid_funnels/triangle_levels.dart';
import 'package:flutter/material.dart';

export 'preview.dart'; // for getLevelPreview()

/// Returns the number of implemented levels
int levelsCount() {
  return LevelTree.levels.length;
}

int get lastIndex => LevelTree.levels.last.levelIndex;

/// Returns the number of defined masks
int masksCount() {
  return LevelTree.levels.fold(0, (p, e) => p + e.masksAmount);
}

/// Estimation on the number of questions (i.e. all random combinations)
num questionsCount() {
  return LevelTree.levels.fold(
    0,
    (p, e) =>
        p +
        e.masksAmount *
            (pow(
              e.maxTotal ~/ (e.solutionRows - 1),
              e.solutionRows,
            )),
  );
}

/// Gets Information whether particular level with index is implemented
bool isLevelImplemented(int index) {
  return LevelTree.getLevelByLevelIndex(index) != null;
}

/// Gets the task screen for Pyramids
Widget openPyramidsTaskScreen(int selectedLevelIndex) {
  return TaskScreen(
    level: LevelTree.getLevelByLevelIndex(selectedLevelIndex)!,
    taskType: TriangleTaskType.pyramid,
  );
}

/// Gets the task screen for Funnels
Widget openFunnelsTaskScreen(int selectedLevelIndex) {
  return TaskScreen(
    level: LevelTree.getLevelByLevelIndex(selectedLevelIndex)!,
  );
}

/// Obtain the level index based on the school year and month
int schoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  return LevelTree.schoolClassToLevelIndex(
    schoolYear,
    schoolMonth,
  );
}
