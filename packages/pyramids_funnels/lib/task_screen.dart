/// Triangles ... matematicke prostredi: souctove trojuhelniky
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pyramid_funnel_levels/models/level/level.dart';
import 'package:pyramid_funnel_levels/models/level_tree/level_tree.dart';
import 'package:pyramids_funnels/models/level_type.dart';
import 'package:pyramids_funnels/models/submission_controller.dart';
import 'package:pyramids_funnels/utils.dart';
import 'package:pyramids_funnels/widgets/task.dart';
import 'package:software_keyboard/keyboard.dart';
import 'package:software_keyboard/keyboard_controller.dart';
import 'package:cvicebnice_overlays/cvicebnice_overlays.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
    required this.level,
    this.taskType = TriangleLevelType.funnel,
  });

  final Level level;
  final TriangleLevelType taskType;

  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  late bool _showBackground;
  late bool taskSubmitted;
  late bool optionsRequested;
  late bool _hintOn;
  late Level _level;

  late SubmissionController submissionController;
  late KeyboardController<int?> keyboardController;

  int? focusedIndex;

  @override
  void initState() {
    _level = widget.level;
//    log("hu $_maskOn");
    _hintOn = false;
    _showBackground = true;
    taskSubmitted = false;
    optionsRequested = false;
    levelInit();

    super.initState();
  }

  void levelInit() {
    _level.generate();

    submissionController = SubmissionController(level: _level)
      ..addListener(_checkSolution)
      ..isSolved = false
      ..isFilled = false;

    keyboardController = KeyboardController<int?>(
      values: submissionController.cells,
    );

    taskSubmitted = false;
    optionsRequested = false;
  }

  void levelRegenerate() {
//    submissionController.dispose();
    levelInit();
//  initState();
  }

  void _checkSolution() {
    log('''Submission: ${submissionController.toString()} : solved: ${submissionController.isSolved}''');
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
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: const Color(0xffECE6E9),
          child: Stack(
            children: <Widget>[
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 80),
                  child: Task(
                    level: _level,
                    submissionController: submissionController,
                    hint: _hintOn,
                    showBackground: _showBackground,
                    renderType: widget.taskType,
                    focusedIndex: focusedIndex,
                    onSelected: (index) => setState(() {
                      focusedIndex = index;
                    }),
                  ),
                ),
              ),

              /// edu guide and its speech / buttons over task screen
              if (!(optionsRequested || taskSubmitted))

                /// do not show Guide layer, when overlay is above

                Positioned(
                  left: 20,
                  top: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            /// must hide keyboard before option overlay is
                            ///  shown
                            optionsRequested = true;
                          });
                        },
                        child: Image.asset(
                          'assets/ada_head_only.png',
                          width: 100,
                        ),
                      ),
                      if (submissionController.isFilled)
                        ElevatedButton(
                          style: stadiumButtonStyle,
                          child: const Text('HOTOVO?'),
                          onPressed: () {
                            setState(() {
                              taskSubmitted = true;
                              final currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
              if (!taskSubmitted && optionsRequested)
                OptionsOverlay(
                  canDecreaseLevel: _level.levelIndex > 2,
                  levelInfoText: '${_level.levelIndex} ze 100',
                  showBackground: _showBackground,
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
                      submissionController.initiateForLevel(_level);
                      optionsRequested = false;
                    });
                  },
                  onSwitchBackgroundImage: () {
                    setState(() {
                      _showBackground = !_showBackground;
                      optionsRequested = false;
                    });
                  },
                  onDecreaseLevel: () {
                    setState(
                      () {
                        _level = LevelTree.getLessDifficultLevel(_level);
                        levelRegenerate();
                        optionsRequested = false;
                      },
                    );
                  },
                ),
              if (taskSubmitted && submissionController.isSolved)
                DoneSuccessOverlay(
                  onNextUpLevel: () {
                    setState(() {
                      _level = LevelTree.getMoreDifficultLevel(_level);
                      levelRegenerate();
                    });
                  },
                  onNextSameLevel: () {
                    setState(
                      levelRegenerate,
                    );
                  },
                  onBack: () {
                    Navigator.of(context).pop();
                  },
                ),
              if (taskSubmitted && !submissionController.isSolved)
                DoneWrongOverlay(
                  onBackToLevel: () {
                    setState(() {
                      taskSubmitted = false;
                    });
                  },
                ),
              Positioned(
                bottom: 0,
                child: (!taskSubmitted && !optionsRequested)
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
      ),
    );
  }
}
