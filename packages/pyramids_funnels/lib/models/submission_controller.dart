import 'package:flutter/material.dart';
import 'package:pyramid_funnel_levels/models/level/level.dart';

class SubmissionController extends ChangeNotifier {
  SubmissionController({required this.level}) {
    cells = List<int?>.generate(
      level.solution.length,
      (_) => null,
    );

    initiateForLevel(level);

    isSolved = false;
    isFilled = false;
  }

  /// data placeholder for up to 10 cells indexed 0.. solution length
  List<int?> cells = [];

  /// whether the submission is correct
  bool isSolved = false;

  /// whether all to be filled cells have some value
  bool isFilled = false;

  /// related level, which must be generated up front
  final Level level;

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

  /// empties the submission but does NOT initiates with the predefined
  /// (visible) values for those cells where mask allows visibility to user
  void eraseSubmission() {
    for (final cell in cells) {
      cells[cells.indexOf(cell)] = null;
    }
  }

  /// apply level data to submission
  /// level solution must be generated before this call!
  void initiateForLevel(Level level) {
    for (var i = 0; i < level.solution.length; i++) {
      cells[i] = level.solutionMask.mask[i] ? level.solution[i] : null;
    }
  }

  @override
  String toString() {
    return cells.map((cell) => '$cell').join(', ');
  }

  /// checks whether the submitted solution is equal to generated solution
  bool checkSolution() {
    var done = true;
    for (var i = 0; i < level.solution.length; i++) {
      if (cells[i] != level.solution[i]) done = false;
    }
    return done;
  }

  /// checks whether all to be submitted cells are non empty
  bool checkIfAllFilled() {
    var filled = true;
    for (var i = 0; i < level.solution.length; i++) {
      // consider only editable cells
      if (level.solutionMask.mask[i] == false) {
        // if some editable cell is empty
        if (cells[i] == null) {
          filled = false;
        }
      }
    }
    return filled;
  }
}
