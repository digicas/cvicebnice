import 'package:flutter/material.dart';

import 'level.dart';

/// Placeholder for submission data and related collection of textcontrollers
///
class SubmissionController extends ChangeNotifier {
  /// data placeholder for cells indexed 0.. amount of questions
  List<TextEditingController> cells;

  /// whether the submission is correct
  bool isSolved;

  /// whether all to be filled cells have some value
  bool isFilled;

  /// Related screen questions (de facto levels), which must be generated up front
  List<Level> screenQuestions;

  /// related level, which must be generated up front
  /// not valid here as rather the list of questions is provided
//  Level _level;

  SubmissionController({this.screenQuestions}) {
    cells = new List<TextEditingController>(screenQuestions.length);

    for (int i = 0; i < cells.length; i++) {
      cells[i] = (TextEditingController());
      cells[i].addListener(onChanged);
    }

    isSolved = false;
    isFilled = false;
  }

  /// called when any of the text cells is updated
  /// notifies listeners
  onChanged() {
    isSolved = checkSolution();
    isFilled = checkIfAllFilled();
    notifyListeners();
//    _printLatestValue();
  }

//  _printLatestValue() {
//    print("Submission: ${toString()}");
//  }

  /// Empties the submission but does NOT initiates with the predefined (visible) values
  /// for those cells where mask allows visibility to user
  void eraseSubmission() {
    cells.forEach((tController) => tController.clear());
  }


  /// disposes all resources as required by [TextEditingController]
  void dispose() {
    cells.forEach((tController) => tController.dispose());
    super.dispose();
  }

  String toString() {
    return (cells.map((cell) => cell.text).join(", "));
  }

  /// checks whether the submitted solution is equal to generated solution
  bool checkSolution() {
    bool done = true;
    for (int i=0; i< screenQuestions.length; i++) {
      int filled = int.tryParse(cells[i].text);
      if (!screenQuestions[i].onCheck(screenQuestions[i].solution, [filled])) done = false;
    }
    return done;
  }

  /// checks whether all to be submitted cells are non empty
  bool checkIfAllFilled() {
    bool filled = true;

    for (var cell in cells) {
      if (cell.text == "") filled = false;
    }

//    if (filled) print("vyplneno");
    return filled;
  }
}
