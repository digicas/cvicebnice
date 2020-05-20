import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'generator.dart';
import 'leveltree.dart';
import 'screen.dart';

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