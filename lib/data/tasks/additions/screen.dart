import 'dart:developer';

import 'package:cvicebnice/data/tasks/additions/generator.dart';
import 'package:cvicebnice/data/tasks/additions/level.dart';
import 'package:cvicebnice/data/tasks/additions/level_tree.dart';
import 'package:cvicebnice/data/tasks/additions/submission_controller.dart';
import 'package:cvicebnice/keyboard/cursor.dart';
import 'package:cvicebnice/keyboard/keyboard.dart';
import 'package:cvicebnice/keyboard/keyboard_controller.dart';
import 'package:cvicebnice/utils/overlays/done_success_overlay.dart';
import 'package:cvicebnice/utils/overlays/done_wrong_overlay.dart';
import 'package:cvicebnice/utils/overlays/options_overlay.dart';
import 'package:cvicebnice/utils/utils.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key, required this.selectedLevelIndex});
  final int selectedLevelIndex;

  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  bool? _showBackground;
  bool? taskSubmitted;
  bool? optionsRequested;
  late LevelTree levelTree;
  late List<Level> questions;

  late Level _level;

  /// Level index selected in the parent Widget
  late int selectedLevelIndex;

  /// Amount of generated questions on the screen
  static const questionsAmount = 5;

  /// Controller for submission / solution checks
  late SubmissionController submissionController;
  late KeyboardController<int?> keyboardController;

  int? focusedIndex;

  @override
  void initState() {
    selectedLevelIndex = widget.selectedLevelIndex;

    _showBackground ??= true;
    taskSubmitted ??= false;
    optionsRequested ??= false;

    questionsControllerInit();

    super.initState();
  }

  /// Initializes the questions for screen for the particular level index
  void questionsControllerInit() {
    levelTree = LevelTree();
    _level = levelTree.getLevelByIndex(selectedLevelIndex)!;
    questions = questionsGenerate(amount: questionsAmount, level: _level);

    submissionController = SubmissionController(screenQuestions: questions);
    submissionController.addListener(_checkSolution);

    keyboardController = KeyboardController<int?>(
      values: submissionController.cells,
      valuesMaxLengths: generateMaxLengths(),
    );

    taskSubmitted = false;
    optionsRequested = false;
  }

  List<int> generateMaxLengths() {
    return List<int>.generate(questions.length, (index) {
      print(levelTree.getLevelByIndex(selectedLevelIndex)?.index);
      if ((levelTree.getLevelByIndex(selectedLevelIndex)?.index ?? 0) > 150) {
        return 6;
      }
      final mask = questions[index].selectedQuestionMask;
      if (mask == 'x+y+w=ZZ' || mask == '100=k+X') {
        return 2;
      }
      return 4;
    });
  }

  /// Regenerates the questions for the screen
  void questionsRegenerate() {
    questionsControllerInit();
  }

  void _checkSolution() {
    log('Submission: ${submissionController.toString()} : '
        'solved: ${submissionController.isSolved}');
    setState(() {});
  }

  @override
  void dispose() {
    submissionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    log('didUpdateWidget: $this');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return CustomKeyboardCovered(
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ColoredBox(
              color: const Color(0xffECE6E9),
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 80),
                      child: QuestionList(
                        questions: questions,
                        // textControllers: submissionController.cells,
                        values: submissionController.cells,
                        focusedIndex: focusedIndex,
                        onSelected: (index) {
                          setState(() => focusedIndex = index);
                        },
//                      textControllers: textControllers,
                      ),
                    ),
                  ),
                  // top scrolling shade
                  Container(
                    width: double.infinity,
                    height: 125,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffECE6E9),
                          Color(0xccECE6E9),
                          Color(0x00ECE6E9),
                        ],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomLeft,
                        stops: [0, 0.6, 1],
                      ),
                    ),
                  ),
                  buildGuideAndButton(context),

                  // Build overlays based on taskscreen states
                  Builder(
                    builder: (context) {
                      if (!taskSubmitted! & optionsRequested!) {
                        return buildOptionsOverlay(context);
                      }
                      if (taskSubmitted!) {
                        return submissionController.isSolved

                            /// task is submitted and solved successfully
                            ? DoneSuccessOverlay(
                                onNextUpLevel: () {
                                  setState(() {
                                    selectedLevelIndex =
                                        levelTree.getMoreDifficultLevelIndex(
                                      selectedLevelIndex,
                                    );
                                    questionsRegenerate();
                                  });
                                },
                                onNextSameLevel: () => setState(
                                  questionsRegenerate,
                                ),
                                onBack: () {
                                  Navigator.of(context).pop();
                                },
                              )

                            /// task is submitted, but not solved
                            : DoneWrongOverlay(
                                onBackToLevel: () {
                                  setState(() {
                                    taskSubmitted = false;
                                  });
                                },
                              );
                      }
                      // no options overlay to show
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: (!taskSubmitted! && !optionsRequested!)
                  ? SoftwareKeyboard<int?>(
                      controller: keyboardController,
                      onValuesChanged: (values) {
                        setState(() => submissionController.cells = values);
                        submissionController.onChanged();
                      },
                      focusedValueIndex: focusedIndex,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build overlay for Options
  ///
  /// Must be inside the TaskScreen class in order to handle options
  Widget buildOptionsOverlay(BuildContext context) {
    /// No shade overlay requested
    if (!optionsRequested!) return Container();

    /// Options menu requested
    return OptionsOverlay(
      canDecreaseLevel: _level.index > 2,
      levelInfoText: '${_level.index} ze 150',
      showBackground: _showBackground!,
      onBackToLevel: () {
        setState(() {
          optionsRequested = false;
        });
      },
      onBack: () {
        Navigator.of(context).pop();
      },
      onRestartLevel: () {
        setState(() {
          submissionController.eraseSubmission();
          optionsRequested = false;
        });
      },
      onSwitchBackgroundImage: () {
        setState(() {
          _showBackground = !_showBackground!;
          optionsRequested = false;
        });
      },
      onDecreaseLevel: () {
        setState(() {
          selectedLevelIndex =
              levelTree.getLessDifficultLevelIndex(selectedLevelIndex);
          questionsRegenerate();
          optionsRequested = false;
        });
      },
    );
  }

  /// Build Guide head and Action button
  ///
  /// Must be inside the TaskScreen class in order to handle options
  Positioned buildGuideAndButton(BuildContext context) {
    return Positioned(
      left: 20,
      top: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                optionsRequested = true;
              });
            },
            child: Image.asset(
              'assets/ada_head_only.png',
              width: 100,
            ),
          ),
//                          Container(width: 20),
          if (submissionController.isFilled)
            ElevatedButton(
              style: stadiumButtonStyle,
              child: const Text('HOTOVO?'),
              onPressed: () {
                setState(() {
                  taskSubmitted = true;
                });
              },
            )
        ],
      ),
    );
  }
}

/// Render set of questions
class QuestionList extends StatelessWidget {
  const QuestionList({
    super.key,
    this.questions = const [],
    this.values = const [],
    this.focusedIndex,
    required this.onSelected,
  });
  final List<Level> questions;
  final List<int?> values;
  final int? focusedIndex;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 130, 0, 0),
      child: Column(
        children: List.generate(
          questions.length,
          (index) => Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: Question(
              // textController: textControllers[index],
              value: values[index],
              onSelected: () => onSelected(index),
              isFocused: focusedIndex == index,
              mask: questions[index].selectedQuestionMask,
              solution: questions[index].solution ?? [],
//                      solution: [4008, 3548, 7556]
            ),
          ),
        ),
      ),
    );
  }
}

/// Render one question
class Question extends StatelessWidget {
  const Question({
    super.key,
    required this.mask,
    required this.solution,
    this.value,
    this.isFocused = false,
    this.preview = false,
    this.onSelected,
  });

  /// Form of the question
  ///
  /// "x+y=Z", "X+y=z", "x+Y=z", "x+y+w=Z", "100=k+X"
  final String mask;

  /// [k, x] or [x,y,z] or [x,y,w,z]
  final List<int> solution;

  final int? value;
  final bool isFocused;

  /// Controller for the editinput
  // final TextEditingController textController;

  /// Whether to render preview
  final bool preview;

  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    if (mask == 'x+y=Z') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QText('${solution[0]}', preview: preview),
          QText('+', preview: preview),
          QText('${solution[1]}', preview: preview),
          QText('=', preview: preview),
          QuestionInputField(
            // textController: textController,
            value: value,
            isFocused: isFocused,
            preview: preview,
            onSelected: onSelected,
          ),
        ],
      );
    }

    if (mask == 'X+y=z') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QuestionInputField(
            value: value,
            isFocused: isFocused,
            preview: preview,
            onSelected: onSelected,
          ),
          QText('+', preview: preview),
          QText('${solution[1]}', preview: preview),
          QText('=', preview: preview),
          QText('${solution[2]}', preview: preview),
        ],
      );
    }

    if (mask == 'x+Y=z') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QText('${solution[0]}', preview: preview),
          QText('+', preview: preview),
          QuestionInputField(
            value: value,
            isFocused: isFocused,
            preview: preview,
            onSelected: onSelected,
          ),
          QText('=', preview: preview),
          QText('${solution[2]}', preview: preview),
        ],
      );
    }

    if (mask == 'x+y+w=ZZ') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QText('${solution[0]}', preview: preview),
          QText('+', preview: preview),
          QText('${solution[1]}', preview: preview),
          QText('+', preview: preview),
          QText('${solution[2]}', preview: preview),
          QText('=', preview: preview),
          QuestionInputField(
            value: value,
            isFocused: isFocused,
            preview: preview,
            length: 2,
            onSelected: onSelected,
          ),
        ],
      );
    }

    if (mask == '100=k+X') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QText('100', preview: preview),
          QText('=', preview: preview),
          QText('${solution[0]}', preview: preview),
          QText('+', preview: preview),
          QuestionInputField(
            value: value,
            isFocused: isFocused,
            preview: preview,
            length: 2,
            onSelected: onSelected,
          ),
        ],
      );
    }

    log('mask $mask not implemented');
    return Container();
  }
}

/// Text part to be rendered for the question
class QText extends StatelessWidget {
  const QText(
    this.text, {
    super.key,
    this.preview = false,
  });

  final String text;

  final bool preview;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: !preview ? 32 : 14),
        ),
      ),
    );
  }
}

/// Editing field
///
/// note keyboardType
class QuestionInputField extends StatelessWidget {
  const QuestionInputField({
    super.key,
    this.value,
    this.length,
    this.preview = false,
    this.isFocused = false,
    this.onSelected,
  });
  final int? value;

  /// Max length of the input value
  final int? length;

  /// Whether to render preview
  final bool preview;
  final bool isFocused;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    if (preview) {
      return Expanded(
        child: Container(
          width: 20,
          height: 16,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0x109C4D82),
          ),
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 250,
          ),
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0x109C4D82),
            border: Border.all(
              width: 2,
              color: isFocused ? const Color(0xff96365f) : Colors.transparent,
            ),
          ),
          child: GestureDetector(
            onTap: onSelected,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value != null ? '$value' : '',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                  if (isFocused) const BlinkingCursor(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
