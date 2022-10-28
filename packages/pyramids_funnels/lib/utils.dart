import 'package:flutter/material.dart';
import 'package:pyramid_funnel_levels/models/level_tree/level_tree.dart';
import 'package:pyramids_funnels/models/level_type.dart';
import 'package:pyramids_funnels/task_screen.dart';

ButtonStyle get stadiumButtonStyle => ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xff96365f),
      ),
    );

Widget openPyramidsTaskScreen(int selectedLevelIndex) {
  return TaskScreen(
    level: LevelTree.getLevelByLevelIndex(selectedLevelIndex)!,
    taskType: TriangleLevelType.pyramid,
  );
}

/// Gets the task screen for Funnels
Widget openFunnelsTaskScreen(int selectedLevelIndex) {
  return TaskScreen(
    level: LevelTree.getLevelByLevelIndex(selectedLevelIndex)!,
  );
}
