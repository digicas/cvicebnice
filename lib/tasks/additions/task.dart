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

import 'package:cvicebnice/constants.dart';
import 'package:cvicebnice/tasks/additions/generator.dart';
import 'package:cvicebnice/tasks/additions/level.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'leveltree.dart';
import 'screen.dart';

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
}

String getLevelDescription(int index) {
  var levelTree = LevelTree();
  var level = levelTree.getLevelByIndex(index);
  if (level == null) return "";
  String text = "";
  text += level.description ?? "Popis ješte není :(";

  // Example is not needed due to preview rendered
//  text += "\n\nPříklad: ";
//  text += level.example ?? "Příklad nám chybí :(";
  return text;
}

String getLevelXid(int index) {
  var levelTree = LevelTree();
  var level = levelTree.getLevelByIndex(index);
  if (level == null) return "!!!";
  if (level.xid == null) return "???";
  return level.xid;
}

/// Gets the levelIndex in [LevelTree] based on whole xid "abcghi"
///
/// Returns -1 if levelIndex is not found.
int getLevelIndexFromXid(String wholeXid) {
  var levelTree = LevelTree();
  return levelTree.getLevelIndexFromXid(wholeXid);
}

/// Generates the preview Widget for the classic additions
Widget getLevelPreview(int levelIndex) {
  var levelTree = LevelTree();
  var level = levelTree.getLevelByIndex(levelIndex);
  if (level == null) return FaIcon(FontAwesomeIcons.handsHelping, size: 48);

  var questions = questionsGenerate(level: level, amount: 5);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: List.generate(
          questions.length,
          (i) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Question(
                textController: null,
                mask: questions[i].selectedQuestionMask,
                solution: questions[i].solution,
                preview: true,
//                      solution: [4008, 3548, 7556]
              )
//            Text("4 + ?? = 15", style: TextStyle(fontSize: 14),),
              )),
    ),
  );
}

/// Generates the string representation of the suitable school classes / months
String getLevelSuitability(int levelIndex) {
  List<List<int>> schoolYearMonth;
  String text = "";
  schoolYearMonth = LevelTree.getMinimumSchoolClassAndMonth(levelIndex);

  String monthText = kMonths[schoolYearMonth[0][1]];
  text += "Vhodné od ${schoolYearMonth[0][0]}. třídy ($monthText)";

  // check whether we have additional occurrence of the level in the year
  if (schoolYearMonth.length > 1) {
    monthText = kMonths[schoolYearMonth[1][1]];
    text += " a od ${schoolYearMonth[1][0]}. třídy ($monthText)";
  }
  return text;
}
