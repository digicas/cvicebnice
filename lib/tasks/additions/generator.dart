import 'package:flutter/foundation.dart';

import 'level.dart';

/// Generates the collection of questions
///
/// tries x times to have unique questions
List<Level> questionsGenerate({Level level, int amount}) {
  var questions = List.generate(amount, (_) => level.clone());

  bool questionsHaveZero = false;
  for (int i = 0; i < questions.length; i++) {
    bool mustRegenerate;
    int tries = 10;
    do {
      questions[i].generate();
      tries--;

      /// avoid generating the same question / solution
      mustRegenerate = false;
      for (int j = 0; j < i; j++) {
        if (listEquals(questions[j].solution, questions[i].solution))
          mustRegenerate = true;
      }

      /// avoid more zeros among questions
      if (questionsHaveZero & questions[i].solution.contains(0))
        mustRegenerate = true;
//        print("$i: $tries: ${questions[i].solution}");
    } while (mustRegenerate & (tries > 0));
    if (questions[i].solution.contains(0)) questionsHaveZero = true;
  }
  return questions;
}
