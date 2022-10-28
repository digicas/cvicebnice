// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:cvicebnice/data/tasks/additions/task.dart' as additions;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pyramid_funnel_levels/utils.dart';
import 'package:pyramids_funnels/utils.dart';
import 'package:pyramids_funnels/widgets/previews/index.dart';

final List<TaskRegisterItem> tasksRegister = [
  TaskRegisterItem(
    xid: 'prm',
    imageAssetName: 'assets/menu_pyramid.png',
    label: 'Pyramidy',
    isLevelImplemented: isLevelImplemented,
    onOpenTaskScreen: openPyramidsTaskScreen,
    onSchoolClassToLevelIndex: schoolClassToLevelIndex,
    onLevelsCount: levelsCount,
    onMasksCount: masksCount,
    onQuestionsCount: questionsCount,
    getLevelPreview: getLevelPreviewPyramid,
    lastIndex: lastIndex,
  ),
  TaskRegisterItem(
    xid: 'fnl',
    imageAssetName: 'assets/menu_funnel.png',
    label: 'Trychtýř',
    isLevelImplemented: isLevelImplemented,
    onOpenTaskScreen: openFunnelsTaskScreen,
    onSchoolClassToLevelIndex: schoolClassToLevelIndex,
    onLevelsCount: levelsCount,
    onMasksCount: masksCount,
    onQuestionsCount: questionsCount,
    getLevelPreview: getLevelPreviewFunnel,
    lastIndex: lastIndex,
  ),
  TaskRegisterItem(
    xid: 'cad',
    imageAssetName: 'assets/menu_additions.png',
    label: 'Sčítání',
    isLevelImplemented: additions.isLevelImplemented,
    onOpenTaskScreen: additions.onOpenTaskScreen,
    onSchoolClassToLevelIndex: additions.onSchoolClassToLevelIndex,
    getLevelDescription: additions.getLevelDescription,
    getLevelSuitability: additions.getLevelSuitability,
    getLevelXid: additions.getLevelXid,
    getLevelIndexFromXid: additions.getLevelIndexFromXid,
    onLevelsCount: additions.levelsCount,
    getLevelPreview: additions.getLevelPreview,
    lastIndex: additions.lastIndex,
  ),
  TaskRegisterItem(
    xid: 'csb',
    imageAssetName: 'assets/menu_subtractions.png',
    label: 'Odčítání',
    lastIndex: 0,
  ),
];

class TaskRegisterItem {
  TaskRegisterItem({
    required this.lastIndex,
    required this.xid,
    required this.imageAssetName,
    required this.label,
    this.getLevelXid = defaultGetLevelXid,
    this.getLevelIndexFromXid = defaultGetLevelIndexFromXid,
    this.isLevelImplemented = defaultLevelIsNotImplemented,
    this.onOpenTaskScreen = defaultOpenTaskScreen,
    this.onSchoolClassToLevelIndex = defaultOnSchoolClassToLevelIndex,
    this.getLevelDescription = defaultLevelDescription,
    this.getLevelPreview = defaultGetLevelPreview,
    this.getLevelSuitability = defaultGetLevelSuitability,
    this.onLevelsCount = defaultLevelsCount,
    this.onMasksCount = defaultMasksCount,
    this.onQuestionsCount = defaultQuestionsCount,
  });

  final String xid;
  final String imageAssetName;
  final String label;
  final int lastIndex;
  bool Function(int index) isLevelImplemented;
  Widget Function(int selectedLevelIndex) onOpenTaskScreen;
  int Function(int schoolYear, int schoolMonth) onSchoolClassToLevelIndex;
  String Function(int index) getLevelDescription;
  String Function(int index) getLevelXid;
  int Function(String levelWholeXid) getLevelIndexFromXid;
  Widget Function(int index) getLevelPreview;
  String Function(int index) getLevelSuitability;
  int Function() onLevelsCount;
  int Function() onMasksCount;
  num Function() onQuestionsCount;

  int get levelsCount => onLevelsCount();
  int get masksCount => onMasksCount();
  int get questionsCount => onQuestionsCount().toInt();
}

extension TaskRegister<TasksRegisterItem> on List<TaskRegisterItem> {
  String getWholeXId(int taskIndex, int levelIndex) =>
      tasksRegister[taskIndex].xid +
      tasksRegister[taskIndex].getLevelXid(levelIndex);

  int getTaskTypeIndexFromXid(String levelXid) {
    if (levelXid.length < 3) return -1;
    final taskXid = levelXid.substring(0, 3).toLowerCase();
    return tasksRegister.indexWhere((task) => task.xid == taskXid);
  }

  int get allTasks => tasksRegister.length;

  int get alLevels => tasksRegister.fold(0, (p, task) => p + task.levelsCount);

  int get allQuestions =>
      tasksRegister.fold(0, (p, task) => p + task.questionsCount);

  int get allMasks => tasksRegister.fold(0, (p, task) => p + task.masksCount);
}

int defaultLevelsCount() => 0;

int defaultMasksCount() => 0;

int defaultQuestionsCount() => 0;

bool defaultLevelIsNotImplemented(_) {
  return false;
}

Widget defaultOpenTaskScreen(_) {
  return const ColoredBox(
    color: Colors.deepOrangeAccent,
    child: Center(
      child: Text('Default Task screen'),
    ),
  );
}

int defaultOnSchoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  log('SchoolYear/schoolMonth -> index not registered in Tasks register!');
  return 0;
}

String defaultLevelDescription(_) {
  log('Getting description not registered in Task register!');
  return 'Popis zatím není vytvořen.';
}

String defaultGetLevelXid(_) {
  log('Getting level xid not registered in Task register!');
  return '???';
}

int defaultGetLevelIndexFromXid(_) {
  log('Getting level index not registered in Task register!');
  return -1;
}

Widget defaultGetLevelPreview(_) {
  return const SizedBox(
    width: 100,
    height: 100,
//    color: Colors.orange,
    child: Center(
      child: FaIcon(
        FontAwesomeIcons.handshakeAngle,
        size: 48,
      ),
    ),
  );
}

String defaultGetLevelSuitability(_) {
  log('Getting suitability not registered in Task register!');
  return '...';
}
