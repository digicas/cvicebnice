// Register (registry) of tasks environments
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import particular tasks modules
import 'tasks/additions/task.dart' as additions;
import 'tasks/pyramidsandfunnels/task.dart' as pyramidsAndFunnels;

/// Particular item in the Tasks register
///
/// Defines image and label for the selection screen
/// Serves as the proxy for calling underlying methods, widgets, screens, atc.
/// of particular task environment
class TasksRegisterItem {
  /// Image of Task for the Selection screen with min. size of 256x256
  ///
  /// Currently rendered to 128x128
  final String imageAssetName;

  /// Name of the Task fot the Selection screen
  final String label;

  /// Callback to provide information whether particular level with index is
  /// implemented
  bool Function(int index) isLevelImplemented;

  /// Callback to render Task screen
  Widget Function(int selectedLevelIndex) onOpenTaskScreen;

  /// Callback to obtain the level index based on the school year and month
  int Function(int schoolYear, int schoolMonth) onSchoolClassToLevelIndex;

  // Statistical functions / callbacks below

  /// Callback to calculate the amount of implemented levels of particular Task
  int Function() onLevelsCount;

  /// Amount of implemented levels of particular Task
  int get levelsCount => onLevelsCount();

  /// Callback to calculate the amount of masks of particular Task
  int Function() onMasksCount;

  /// Amount of masks of particular Task
  int get masksCount => onMasksCount();

  /// Callback to calculate the amount of questions of particular Task
  ///
  /// This might be very approximate as all random generated combinations are
  /// calculated
  int Function() onQuestionsCount;

  ///  Amount of tasks of particular Task
  int get questionsCount => onQuestionsCount();

  TasksRegisterItem(
      {@required this.imageAssetName,
      @required this.label,
      this.isLevelImplemented = defaultLevelIsNotImplemented,
      this.onOpenTaskScreen = defaultOpenTaskScreen,
      this.onSchoolClassToLevelIndex = defaultOnSchoolClassToLevelIndex,
      this.onLevelsCount = defaultLevelsCount,
      this.onMasksCount = defaultMasksCount,
      this.onQuestionsCount = defaultQuestionsCount});
}


/// TasksRegister methods
extension TaskRegister<TasksRegisterItem> on List<TasksRegisterItem> {
  /// Total sum of all registered Tasks
  int get allTasks => this.length;

  /// Total sum of all implemented levels
  int get allLevels => tasksRegister.fold(0, (p, task) {
        print("task: ${task.label} levels: ${task.levelsCount}");
        return p + task.levelsCount;
      });

  /// Total sum of all implemented questions (i.e. all random combinations)
  int get allQuestions =>
      tasksRegister.fold(0, (p, task) => p + task.questionsCount);

  /// Total sum of all defined Masks
  int get allMasks => tasksRegister.fold(0, (p, task) => p + task.masksCount);
}

/// Register of Tasks (environments) for selection on the selection / main screens
final List<TasksRegisterItem> tasksRegister = [
  TasksRegisterItem(
      imageAssetName: "assets/menu_pyramid.png",
      label: "Pyramidy",
      isLevelImplemented: pyramidsAndFunnels.isLevelImplemented,
      onOpenTaskScreen: pyramidsAndFunnels.openPyramidsTaskScreen,
      onSchoolClassToLevelIndex: pyramidsAndFunnels.schoolClassToLevelIndex,
      onLevelsCount: pyramidsAndFunnels.levelsCount,
      onMasksCount: pyramidsAndFunnels.masksCount,
      onQuestionsCount: pyramidsAndFunnels.questionsCount),
  TasksRegisterItem(
      imageAssetName: "assets/menu_funnel.png",
      label: "Trychtýř",
      isLevelImplemented: pyramidsAndFunnels.isLevelImplemented,
      onOpenTaskScreen: pyramidsAndFunnels.openFunnelsTaskScreen,
      onSchoolClassToLevelIndex: pyramidsAndFunnels.schoolClassToLevelIndex,
      onLevelsCount: pyramidsAndFunnels.levelsCount,
      onMasksCount: pyramidsAndFunnels.masksCount,
      onQuestionsCount: pyramidsAndFunnels.questionsCount),
  TasksRegisterItem(
    imageAssetName: "assets/menu_additions.png",
    label: "Sčítání",
    isLevelImplemented: additions.isLevelImplemented,
    onOpenTaskScreen: (index) => additions.TaskScreen(
      selectedLevelIndex: index,
    ),
    onSchoolClassToLevelIndex: additions.onSchoolClassToLevelIndex,
    onLevelsCount: additions.levelsCount,
  ),
  TasksRegisterItem(
    imageAssetName: "assets/menu_subtractions.png",
    label: "Odčítání",
    onLevelsCount: defaultLevelsCount,
  ),
];

// Default callbacks for methods,
// which might not be implemented yet in corresponding task.dart file

int defaultLevelsCount() => 0;

int defaultMasksCount() => 0;

int defaultQuestionsCount() => 0;

bool defaultLevelIsNotImplemented(_) {
  print("Level check existance not defined in Tasks register!");
  return false;
}

Widget defaultOpenTaskScreen(_) {
  return Container(
    color: Colors.deepOrangeAccent,
    child: Center(
      child: Text("Default Task screen"),
    ),
  );
}

int defaultOnSchoolClassToLevelIndex(int schoolYear, int schoolMonth) {
  print("SchoolYear/schoolMonth -> index not implemented in Tasks register!");
  return 0;
}
