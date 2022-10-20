import 'package:cvicebnice/data/tasks/additions/level.dart';
import 'package:flutter/material.dart';

/// Placeholder for submission data and related collection of textcontrollers
///
class SubmissionController extends ChangeNotifier {
  /// related level, which must be generated up front
  /// not valid here as rather the list of questions is provided
//  Level _level;

  SubmissionController({required this.screenQuestions}) {
    cells = List<int?>.generate(
      screenQuestions.length,
      (_) => null,
    );
    // ..addListener(onChanged);

    isSolved = false;
    isFilled = false;
  }

  /// data placeholder for cells indexed 0.. amount of questions
  List<int?> cells = [];

  /// whether the submission is correct
  bool isSolved = false;

  /// whether all to be filled cells have some value
  bool isFilled = false;

  /// Related screen questions (de facto levels), which must be generated
  /// up front
  List<Level> screenQuestions;

  /// called when any of the text cells is updated
  /// notifies listeners
  void onChanged() {
    isSolved = checkSolution();
    isFilled = checkIfAllFilled();
    notifyListeners();
//    _printLatestValue();
  }

//  _printLatestValue() {
//    log("Submission: ${toString()}");
//  }

  /// Empties the submission but does NOT initiates with the predefined
  ///  (visible) values
  /// for those cells where mask allows visibility to user
  void eraseSubmission() {
    for (final value in cells) {
      cells[cells.indexOf(value)] = null;
    }
  }

  // /// disposes all resources as required by [TextEditingController]
  // @override
  // void dispose() {
  //   for (final tController in cells) {
  //     tController.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  String toString() {
    return cells.map((cell) => '$cell').join(', ');
  }

  /// checks whether the submitted solution is equal to generated solution
  bool checkSolution() {
    var done = true;
    for (var i = 0; i < screenQuestions.length; i++) {
      final filled = cells.elementAt(i);
      if (filled == null) {
        return false;
      }
      if (!Level.checkSubmission(
        screenQuestions[i].solution!,
        [filled],
        screenQuestions[i].selectedQuestionMask,
      )) {
        done = false;
      }
      //      if (!screenQuestions[i].onCheck(screenQuestions[i].solution,
      //      [filled])) done = false;
    }
    return done;
  }

  /// checks whether all to be submitted cells are non empty
  bool checkIfAllFilled() {
    var filled = true;

    for (final cell in cells) {
      if (cell == null) filled = false;
    }

//    if (filled) log("vyplneno");
    return filled;
  }
}
