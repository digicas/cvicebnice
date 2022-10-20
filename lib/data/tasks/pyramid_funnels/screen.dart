//import 'dart:ffi';

//import './overlays/shaderoverlay.dart';

import 'dart:developer';

// import 'package:zoom_widget/zoom_widget.dart';

import 'package:cvicebnice/data/tasks/pyramid_funnels/triangle_levels.dart';
import 'package:cvicebnice/keyboard/cursor.dart';
import 'package:cvicebnice/keyboard/keyboard.dart';
import 'package:cvicebnice/keyboard/keyboard_controller.dart';
import 'package:cvicebnice/utils/overlays/done_success_overlay.dart';
import 'package:cvicebnice/utils/overlays/done_wrong_overlay.dart';
import 'package:cvicebnice/utils/overlays/options_overlay.dart';
import 'package:cvicebnice/utils/utils.dart';
import 'package:flutter/material.dart';

//import 'package:cool_ui/cool_ui.dart';

/// Triangles ... matematicke prostredi: souctove trojuhelniky
class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
    required this.level,
    this.taskType = TriangleTaskType.funnel,
  });

  final Level level;
  final TriangleTaskType taskType;

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
                  child: Funnel(
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

              ///
              /// Overlay for options and task submission
              ///
              ///
              ///
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

/// type of the task for rendering
enum TriangleTaskType { pyramid, funnel }

/// renders the pyramid or funnel widget based on the RenderType
class Funnel extends StatelessWidget {
  const Funnel({
    super.key,
    required this.level,
    required this.submissionController,
    required this.hint,
    this.showBackground = true,
    this.renderType = TriangleTaskType.funnel,
    this.onSelected,
    this.focusedIndex,
  });
  final Level level;
  final SubmissionController submissionController;
  final bool hint;
  final bool showBackground;

  /// task type to render (RenderType.Pyramid or RenderType.Funnel)
  final TriangleTaskType renderType;

  final void Function(int)? onSelected;
  final int? focusedIndex;

  @override
  Widget build(BuildContext context) {
//    log(level);

    const rowStartIndex = [null, 0, 1, 3, 6, 10];

    final renderRows = <Widget>[];

    for (var row = 1; row <= level.solutionRows; row++) {
      final cells = <Cell>[];

      for (var i = rowStartIndex[row]!; i < rowStartIndex[row]! + row; i++) {
        cells.add(
          Cell(
            value: submissionController.cells[i],
            masked: !level.solutionMask.mask[i],
            onSelected: () {
              if (!level.solutionMask.mask[i]) onSelected?.call(i);
            },
            isFocused: focusedIndex == i,
            hint: hint,
            cellType: renderType == TriangleTaskType.funnel
                ? CellType.bubble
                : CellType.box,
          ),
        );
      }

      if (renderType == TriangleTaskType.funnel) {
        // INSERT row for funnel rendering
        renderRows.insert(
          0,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: cells,
          ),
        );
      }

      if (renderType == TriangleTaskType.pyramid) {
        // ADD row for pyramid rendering
        renderRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: cells,
          ),
        );
      }
    } // end for loop build rows

    if (renderType == TriangleTaskType.funnel) {
      return Center(
        child: Container(
//              color: Color(0xff9C4D82),
          padding: const EdgeInsets.fromLTRB(0, 64, 0, 0),
          child: CustomPaint(
            painter: showBackground ? FunnelPainter() : null,
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: renderRows,
              ),
            ),
          ),
        ),
      );
    }

    /// render pyramid
    return Stack(
      children: <Widget>[
        Center(
          child: CustomPaint(
            // https://api.flutter.dev/flutter/widgets/CustomPaint-class.html
//              size: Size(200,200),
            painter: showBackground ? PyramidPainter() : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: renderRows,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// background painting for Pyramid
class PyramidPainter extends CustomPainter {
  PyramidPainter() {
    _paintL = Paint()
      ..color = const Color(0xFFA88B5A)
      ..style = PaintingStyle.fill;
    _paintR = Paint()
      ..color = const Color(0xFFC0A36B)
      ..style = PaintingStyle.fill;
  }
  late final Paint _paintL;
  late final Paint _paintR;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, _paintL);
    path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, _paintR);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// Background painting for Funnel
class FunnelPainter extends CustomPainter {
  FunnelPainter({this.factor = 1}) {
    _paint = Paint()
      ..color = const Color(0xff829c4d)
      ..style = PaintingStyle.fill;
  }
  late final Paint _paint;
  final double factor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(-20 * factor, 8 * factor)
      ..lineTo(size.width + 20 * factor, 8 * factor)
      ..lineTo(size.width / 2 + 30 * factor, size.height - 5 * factor)
      ..lineTo(size.width / 2 + 30 * factor, size.height + 68 * factor)
      ..lineTo(size.width / 2 - 30 * factor, size.height + 48 * factor)
      ..lineTo(size.width / 2 - 30 * factor, size.height - 5 * factor)
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// type of the Cell for rendering
enum CellType { box, bubble }

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.value,
    this.masked = false,
    required this.hint,
    this.cellType = CellType.box,
    this.onSelected,
    this.isFocused = false,
  });
  final int? value;
  final bool masked;
  final bool hint;
  final CellType cellType;
  final VoidCallback? onSelected;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    /// widgets for Funnel's bubble
    if (cellType == CellType.bubble) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: !masked ? const Color(0xff9C4D82) : const Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isFocused ? const Color(0xff9C4D82) : Colors.transparent,
              width: 4,
            ),
            boxShadow: !masked
                ? []
                : const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
          ),
          child: Center(
            child: !masked
                ? Text(
                    '$value',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xffeeeeee),
                      fontSize: 22,
                    ),
                  )
                : GestureDetector(
                    onTap: onSelected,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value != null ? '$value' : '',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          if (isFocused)
                            const BlinkingCursor(
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      );
    }

    /// basic rendering - Boxes for Pyramid
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          color: masked ? Colors.grey[200] : Colors.grey[400],
          border: Border.all(
            width: isFocused ? 2 : 1,
            color: isFocused ? const Color(0xff9C4D82) : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: !masked
              ? []
              : const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
        ),
        child: Center(
          child: !masked
              ? Text(
                  '$value',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                )
              : GestureDetector(
                  onTap: onSelected,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value != null ? '$value' : '',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        if (isFocused)
                          const BlinkingCursor(
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
