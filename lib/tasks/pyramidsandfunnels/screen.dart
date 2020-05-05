//import 'dart:ffi';

//import './overlays/shaderoverlay.dart';
import '../../screens/overlays/donesuccessoverlay.dart';
import '../../screens/overlays/donewrongoverlay.dart';
import '../../screens/overlays/optionsoverlay.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'triangle_levels.dart';
import '../../widgets/small_numeric_keyboard.dart';
//import 'package:zoom_widget/zoom_widget.dart';

import 'package:flutter/services.dart';
import 'package:security_keyboard/keyboard_manager.dart';
import 'package:security_keyboard/keyboard_media_query.dart';

//import 'package:cool_ui/cool_ui.dart';

/// Triangles ... matematicke prostredi: souctove trojuhelniky
class TaskScreen extends StatefulWidget {
  final Level level;
  final TriangleTaskType taskType;

  TaskScreen({this.level, this.taskType = TriangleTaskType.Funnel});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _hintOn;
  bool _showBackground;
  bool taskSubmitted;
  bool optionsRequested;
  Level _level;

  SubmissionController submissionController;

  @override
  void initState() {
    _level = widget.level;
//    print("hu $_maskOn");
    _hintOn ??= false;
    _showBackground ??= true;
    taskSubmitted ??= false;
    optionsRequested ??= false;
    levelInit();

    super.initState();
  }

  void levelInit() {
    _level.generate();
    submissionController = SubmissionController(level: _level);
    submissionController.addListener(_checkSolution);
    taskSubmitted = false;
    optionsRequested = false;
  }

  void levelRegenerate() {
//    submissionController.dispose();
    levelInit();
//  initState();
  }

  _checkSolution() {
    print(
        "Submission: ${submissionController.toString()} : solved: ${submissionController.isSolved}");
    setState(() {});
  }

  @override
  void dispose() {
    submissionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    print('didUpdateWidget: $this');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: KeyboardMediaQuery(
        child: Builder(builder: (context) {
          KeyboardManager.init(context);
          return Scaffold(
//            appBar: AppBar(
//              title: Text("Úroveň: ${_level.levelIndex}"),
////              actions: <Widget>[
////                _showBackground
////                    ? RaisedButton(
////                        color: Color(0xff2ba06b),
////                        child: Icon(Icons.image,
////                            color: Color(0xff415a70), size: 32),
////                        onPressed: () {
////                          setState(() {
////                            _showBackground = false;
////                          });
////                        },
////                      )
////                    : RaisedButton(
//////                  color: Colors.black,
////                        child: Icon(Icons.image, size: 32),
////                        onPressed: () {
////                          setState(() {
////                            _showBackground = true;
////                          });
////                        },
////                      )
////              ],
////              bottom: PreferredSize(
////                  preferredSize: Size.fromHeight(20),
////                  child: Text(
////                      "${submissionController.isFilled ? submissionController.isSolved ? "SUPER!" : "Není to ono" : "Něco chybí"}: ${submissionController.toString()}")),
//            ),
            body: SafeArea(
              child: Container(
                color: Color(0xffECE6E9),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
                        child: Funnel(
                          level: _level,
                          submissionController: submissionController,
                          hint: _hintOn,
                          showBackground: _showBackground,
                          renderType: widget.taskType,
                        ),
                      ),
                    ),

                    /// edu guide and its speech / buttons over task screen
                    (optionsRequested || taskSubmitted)

                        /// do not show Guide layer, when overlay is above
                        ? Container()
                        : Positioned(
                            left: 20,
                            top: 20,
                            right: 20,
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        /// must hide keyboard before option overlay is shown
                                        removeEditableFocus(context);
                                        optionsRequested = true;
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/ada_head_only.png",
                                      width: 100,
                                    ),
                                  ),
//                          Container(width: 20),

                                  submissionController.isFilled
                                      ? RaisedButton(
                                          shape: StadiumBorder(),
                                          child: Text("HOTOVO?"),
                                          onPressed: () {
                                            setState(() {
                                              taskSubmitted = true;
                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
//                                        KeyboardManager.hideKeyboard();
                                            });
                                          },
                                        )
                                      : Container(),
                                ]),
                          ),

                    ///
                    /// Overlay for options and task submission
                    ///
                    !taskSubmitted

                        /// task is not submitted -> check if option overlay was requested
                        ? !optionsRequested

                            /// no shade overlay needed
                            ? Container()

                            /// Options menu requested
                            : OptionsOverlay(
                                canDecreaseLevel: (_level.levelIndex > 2),
                                levelInfoText:
                                    _level.levelIndex.toString() + " ze 100",
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
                                    submissionController
                                        .initiateForLevel(_level);
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
                                  setState(() {
                                    _level =
                                        LevelTree.getLessDifficultLevel(_level);
                                    levelRegenerate();
                                    optionsRequested = false;
                                  });
                                },
                              )
                        : submissionController.isSolved

                            /// task is submitted and solved successfully
                            ? DoneSuccessOverlay(
                                onNextUpLevel: () {
                                  setState(() {
                                    _level =
                                        LevelTree.getMoreDifficultLevel(_level);
                                    levelRegenerate();
                                  });
                                },
                                onNextSameLevel: () {
                                  setState(() {
                                    levelRegenerate();
                                  });
                                },
                                onBack: () {
                                  Navigator.of(context).pop();
                                },
                              )

                            /// task is submitted, but not solved
                            : DoneWrongOverlay(
                                onBackToLevel: () {
                                  setState(() {
                                    taskSubmitted = false;
//                                    KeyboardManager.openKeyboard();
                                  });
                                },
                              ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      onWillPop: _requestPop,
    );
  }

  Future<bool> _requestPop() {
    bool b = true;
    if (KeyboardManager.isShowKeyboard) {
      KeyboardManager.hideKeyboard();
      b = false;
    }
//    return Future.value(true); // go screen back immediately - nefunguje @web :(
    return Future.value(b); // first hide keyboard, go screen back next time
  }
}

void removeEditableFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
// KeyboardManager.hideKeyboard();
}

/// type of the task for rendering
enum TriangleTaskType { Pyramid, Funnel }

/// renders the pyramid or funnel widget based on the RenderType
class Funnel extends StatelessWidget {
  final Level level;
  final SubmissionController submissionController;
  final bool hint;
  final bool showBackground;

  /// task type to render (RenderType.Pyramid or RenderType.Funnel)
  final TriangleTaskType renderType;

  Funnel(
      {Key key,
      this.level,
      this.submissionController,
      this.hint,
      this.showBackground,
      this.renderType = TriangleTaskType.Funnel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    print(level);

    const List<int> _rowStartIndex = [null, 0, 1, 3, 6, 10];

    List<Widget> renderRows = [];

    for (int row = 1; row <= level.solutionRows; row++) {
      List<Cell> cells = [];

      for (int i = _rowStartIndex[row]; i < _rowStartIndex[row] + row; i++) {
        cells.add(Cell(
          value: level.solution[i],
          textController: submissionController.cells[i],
          masked: !level.solutionMask.mask[i],
          hint: hint,
          cellType: renderType == TriangleTaskType.Funnel
              ? CellType.Bubble
              : CellType.Box,
        ));
      }

      if (renderType == TriangleTaskType.Funnel) {
        // INSERT row for funnel rendering
        renderRows.insert(
            0,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: cells,
            ));
      }

      if (renderType == TriangleTaskType.Pyramid) {
        // ADD row for pyramid rendering
        renderRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: cells,
        ));
      }
    } // end for loop build rows

    if (renderType == TriangleTaskType.Funnel) {
      return Center(
          child: Container(
//              color: Color(0xff9C4D82),
              padding: EdgeInsets.fromLTRB(0, 64, 0, 0),
              child: CustomPaint(
                painter: showBackground ? FunnelPainter() : null,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: renderRows,
                    )),
              )));
    }

    /// render pyramid
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
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
        ),
      ],
    );
  }
}

/// background painting for Pyramid
class PyramidPainter extends CustomPainter {
  Paint _paintL;
  Paint _paintR;

  PyramidPainter() {
    _paintL = Paint()
      ..color = Color(0xFFA88B5A)
      ..style = PaintingStyle.fill;
    _paintR = Paint()
      ..color = Color(0xFFC0A36B)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, _paintL);
    path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, _paintR);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// Background painting for Funnel
class FunnelPainter extends CustomPainter {
  Paint _paint;

  FunnelPainter() {
    _paint = Paint()
      ..color = Color(0xff829c4d)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..moveTo(-20, 8)
      ..lineTo(size.width + 20, 8)
      ..lineTo(size.width / 2 + 30, size.height - 5)
      ..lineTo(size.width / 2 + 30, size.height + 68)
      ..lineTo(size.width / 2 - 30, size.height + 48)
      ..lineTo(size.width / 2 - 30, size.height - 5 )
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// type of the Cell for rendering
enum CellType { Box, Bubble }

class Cell extends StatelessWidget {
  final int value;
  final bool masked;
  final bool hint;
  final CellType cellType;

  final TextEditingController textController;

  Cell(
      {Key key,
      @required this.value,
      this.masked = false,
      this.hint,
      this.textController,
      this.cellType = CellType.Box})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// widgets for Funnel's bubble
    if (cellType == CellType.Bubble) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: !this.masked ? Color(0xff9C4D82) : Color(0xffeeeeee),
                  borderRadius: BorderRadius.circular(32.0),
                  border: Border.all(
                    color: Color(0xff9C4D82),
                    width: 4,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: !this.masked
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                            offset: Offset(4.0, 4.0),
                          ),
                        ]),
              child: Center(
                child: !this.masked
                    ? Text(value.toString(),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          color: Color(0xffeeeeee),
                          fontSize: 24,
                        ))
                    : TextField(
                        /// enableInteractiveSelection must NOT be false, otherwise KeyboardController error
//                  enableInteractiveSelection: false,
                        keyboardType: SmallNumericKeyboard.text,
//                  keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        controller: textController,
                        cursorColor: Color(0xffa02b5f),
                        autocorrect: false,
                        maxLength: 4,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
//            readOnly: true,
//            showCursor: true,
                        // hide length counter and underline
                        decoration: null,
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                      ),

                //
              )));
    }

    /// basic rendering - Boxes for Pyramid
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
//        margin: const EdgeInsets.all(2.0),
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          color: this.masked ? Colors.grey[200] : Colors.grey[400],
          border: Border.all(
            color: Colors.black,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: !this.masked
              ? []
              : [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: Offset(4.0, 4.0),
                  ),
                ],
        ),
        child: Center(
          child: !this.masked
              ? Text(value.toString(),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ))
              : TextField(
                  /// enableInteractiveSelection must NOT be false, otherwise KeyboardController error
//                  enableInteractiveSelection: false,
                  keyboardType: SmallNumericKeyboard.text,
//                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: textController,
                  cursorColor: Color(0xffa02b5f),
                  autocorrect: false,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
//            readOnly: true,
//            showCursor: true,
                  // hide length counter and underline
                  decoration: null,
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                ),

//          child: Text(
//            (!this.hint && this.masked) ? "" : value.toString(),
//            overflow: TextOverflow.fade,
//            softWrap: false,
//            style: TextStyle(
//              color: !this.masked ? Colors.black : Colors.black12,
//              fontSize: 24,
//            ),
//          ),
        ),
      ),
    );
  }
}
