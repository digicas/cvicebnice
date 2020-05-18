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
  /// Unique external ID of the task environment
  ///
  /// generated using https://shortunique.id/ or https://pypi.org/project/shortuuid/
  /// for each environment definition so the code can be used such as zvm-uhv
  /// Scope of uniqueness is within the [taskRegister], therefore 3 characters
  /// should be enough. Can be used in URLs, ...
  /// Is defined forever - does not change.
  final String xid;

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

  /// Callback to obtain the description text of particular level index
  String Function(int index) getLevelDescription;

  /// Callback to get the level external ID (xid)
  String Function(int index) getLevelXid;

  /// Callback to ge the level internal index
  ///
  /// Must return -1 if not found
  int Function(String levelWholeXid) getLevelIndexFromXid;

  /// Callback to return the Widget for preview of the screen for
  /// the Description Pane
  Widget Function(int index) getLevelPreview;

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
      {@required this.xid,
      @required this.imageAssetName,
      @required this.label,
      this.getLevelXid = defaultGetLevelXid,
      this.getLevelIndexFromXid = defaultGetLevelIndexFromXid,
      this.isLevelImplemented = defaultLevelIsNotImplemented,
      this.onOpenTaskScreen = defaultOpenTaskScreen,
      this.onSchoolClassToLevelIndex = defaultOnSchoolClassToLevelIndex,
      this.getLevelDescription = defaultLevelDescription,
      this.getLevelPreview = defaultGetLevelPreview,
      this.onLevelsCount = defaultLevelsCount,
      this.onMasksCount = defaultMasksCount,
      this.onQuestionsCount = defaultQuestionsCount});
}

/// TasksRegister methods
extension TaskRegister<TasksRegisterItem> on List<TasksRegisterItem> {
  /// Gets the <task>xid-<level>xid for sharing purposes
  String getWholeXid(int taskIndex, int levelIndex) {
    return tasksRegister[taskIndex].xid +
        tasksRegister[taskIndex].getLevelXid(levelIndex);
  }

  /// Gets the Task Type in [tasksRegister] based on whole xid "abcghi"
  ///
  /// Returns -1 if Task Type is not found.
  int getTaskTypeIndexFromXid(String levelXid) {
    if (levelXid == null) return -1;
    if (levelXid.length < 3) return -1;
    var taskXid = levelXid.substring(0, 3).toLowerCase();
    return tasksRegister.indexWhere((taskType) => taskType.xid == taskXid);
  }

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
      xid: "prm",
      imageAssetName: "assets/menu_pyramid.png",
      label: "Pyramidy",
      isLevelImplemented: pyramidsAndFunnels.isLevelImplemented,
      onOpenTaskScreen: pyramidsAndFunnels.openPyramidsTaskScreen,
      onSchoolClassToLevelIndex: pyramidsAndFunnels.schoolClassToLevelIndex,
      onLevelsCount: pyramidsAndFunnels.levelsCount,
      onMasksCount: pyramidsAndFunnels.masksCount,
      onQuestionsCount: pyramidsAndFunnels.questionsCount),
  TasksRegisterItem(
      xid: "fnl",
      imageAssetName: "assets/menu_funnel.png",
      label: "Trychtýř",
      isLevelImplemented: pyramidsAndFunnels.isLevelImplemented,
      onOpenTaskScreen: pyramidsAndFunnels.openFunnelsTaskScreen,
      onSchoolClassToLevelIndex: pyramidsAndFunnels.schoolClassToLevelIndex,
      onLevelsCount: pyramidsAndFunnels.levelsCount,
      onMasksCount: pyramidsAndFunnels.masksCount,
      onQuestionsCount: pyramidsAndFunnels.questionsCount),
  TasksRegisterItem(
    xid: "cad",
    imageAssetName: "assets/menu_additions.png",
    label: "Sčítání",
    isLevelImplemented: additions.isLevelImplemented,
    onOpenTaskScreen: (index) => additions.TaskScreen(
      selectedLevelIndex: index,
    ),
    onSchoolClassToLevelIndex: additions.onSchoolClassToLevelIndex,
    getLevelDescription: additions.getLevelDescription,
    getLevelXid: additions.getLevelXid,
    getLevelIndexFromXid: additions.getLevelIndexFromXid,
    onLevelsCount: additions.levelsCount,
    getLevelPreview: additions.getLevelPreview,
  ),
  TasksRegisterItem(
    xid: "csb",
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
  print("Level check existance not registered in Tasks register!");
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
  print("SchoolYear/schoolMonth -> index not registered in Tasks register!");
  return 0;
}

String defaultLevelDescription(_) {
  print("Getting description not registered in Task register!");
  return "";
}

String defaultGetLevelXid(_) {
  print("Getting level xid not registered in Task register!");
  return "???";
}

int defaultGetLevelIndexFromXid(_) {
  print("Getting level index not registered in Task register!");
  return -1;
}

Widget defaultGetLevelPreview(_) {
  return Container(
    width: 100,
    height: 100,
//    color: Colors.orange,
    child: Center(child: Text("Náhled není k dispozici :(")),
  );
}
