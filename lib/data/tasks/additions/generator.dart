import 'package:cvicebnice/data/tasks/additions/level.dart';
import 'package:flutter/foundation.dart';

/// Generates the collection of questions
///
/// tries x times to have unique questions
List<Level> questionsGenerate({required Level level, required int amount}) {
  final questions = List.generate(amount, (_) => level.clone());

  var questionsHaveZero = false;
  for (var i = 0; i < questions.length; i++) {
    bool mustRegenerate;
    var tries = 10;
    do {
      questions[i].generate();
      tries--;

      /// avoid generating the same question / solution
      mustRegenerate = false;
      for (var j = 0; j < i; j++) {
        if (listEquals(questions[j].solution, questions[i].solution)) {
          mustRegenerate = true;
        }
      }

      /// avoid more zeros among questions
      if (questionsHaveZero & questions[i].solution!.contains(0)) {
        mustRegenerate = true;
      }
//        log("$i: $tries: ${questions[i].solution}");
    } while (mustRegenerate & (tries > 0));
    if (questions[i].solution!.contains(0)) questionsHaveZero = true;
  }
  return questions;
}
