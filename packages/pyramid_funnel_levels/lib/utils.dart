import 'dart:developer' as dev;
import 'dart:math';

import 'package:pyramid_funnel_levels/models/level_tree/level_tree.dart';

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
  dev.log('Checking if pyramid level is implemented $index');
  return LevelTree.getLevelByLevelIndex(index) != null;
}

/// Obtain the level index based on the school year and month
int schoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  return LevelTree.schoolClassToLevelIndex(
    schoolYear,
    schoolMonth,
  );
}
