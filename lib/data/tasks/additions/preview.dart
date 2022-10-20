import 'package:cvicebnice/data/tasks/additions/generator.dart';
import 'package:cvicebnice/data/tasks/additions/level_tree.dart';
import 'package:cvicebnice/data/tasks/additions/screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Generates the preview Widget for the classic additions
Widget getLevelPreview(int levelIndex) {
  final level = LevelTree().getLevelByIndex(levelIndex);
  if (level == null) {
    return const FaIcon(
      FontAwesomeIcons.handshakeAngle,
      size: 48,
    );
  }

  final questions = questionsGenerate(level: level, amount: 5);

  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      children: List.generate(
        questions.length,
        (i) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Question(
            // textController: TextEditingController(),
            mask: questions[i].selectedQuestionMask,
            solution: questions[i].solution ?? [],
            preview: true,
//                      solution: [4008, 3548, 7556]
          ),
//            Text("4 + ?? = 15", style: TextStyle(fontSize: 14),),
        ),
      ),
    ),
  );
}
