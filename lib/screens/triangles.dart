//import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pyramida/models/triangle_levels.dart';
import 'package:pyramida/widgets/small_numeric_keyboard.dart';
//import 'package:zoom_widget/zoom_widget.dart';

import 'package:flutter/services.dart';
import 'package:security_keyboard/keyboard_manager.dart';
import 'package:security_keyboard/keyboard_media_query.dart';

//import 'package:cool_ui/cool_ui.dart';

/// triangles ... matematicke prostredi: souctove trojuhelniky

class TaskScreen extends StatefulWidget {
  final Level level;
  final TriangleTaskType taskType;
  final Widget taskWidget;

  TaskScreen({this.level, this.taskType = TriangleTaskType.Funnel, this.taskWidget});

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
                        child: getTaskWidget(),
                      ),
                    ),

                    /// edu guide and its speech / buttons over task screen
                    (optionsRequested || taskSubmitted)

                        /// do not show it, when overlay is above
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

  Widget getTaskWidget() {
    if(widget.taskType == TriangleTaskType.SpiderWeb){
      return SpiderWeb(
        level: _level,
        submissionController: submissionController,
        hint: _hintOn,
        showBackground: _showBackground,
        renderType: widget.taskType,
      );
    }
    return Funnel(
                        level: _level,
                        submissionController: submissionController,
                        hint: _hintOn,
                        showBackground: _showBackground,
                        renderType: widget.taskType,
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

/// Overlay screen when successful submission (incl. buttons to navigate next)
class DoneSuccessOverlay extends StatelessWidget {
  const DoneSuccessOverlay(
      {Key key, this.onNextUpLevel, this.onNextSameLevel, this.onBack})
      : super(key: key);

  final VoidCallback onNextUpLevel;
  final VoidCallback onNextSameLevel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ShaderOverlay(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/ada_full_body_correct.png",
                width: 120,
              ),
              Container(width: 16),
              Expanded(
                  child: Container(
                child: Text(
                  "VÝBORNĚ!\n\nTak a můžeš pokračovat.",
                  softWrap: true,
                ),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              )),
            ],
          ),
//          Container(height: 20,),
          RaisedButton.icon(
            label: Text("ZKUSIT TĚŽŠÍ"),
            icon: Icon(Icons.file_upload),
            shape: StadiumBorder(),
            onPressed: onNextUpLevel,
          ),
          RaisedButton.icon(
            label: Text("JEŠTĚ JEDNOU STEJNĚ TĚŽKOU"),
            icon: Icon(Icons.compare_arrows),
            shape: StadiumBorder(),
            onPressed: onNextSameLevel,
          ),
          RaisedButton.icon(
            label: Text("ZPĚT NA VÝBĚR TŘÍDY"),
            icon: Icon(Icons.assignment),
            shape: StadiumBorder(),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

class DoneWrongOverlay extends StatelessWidget {
  const DoneWrongOverlay({Key key, this.onBackToLevel}) : super(key: key);

  final VoidCallback onBackToLevel;

  @override
  Widget build(BuildContext context) {
    return ShaderOverlay(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/ada_full_body_wrong.png",
                width: 100,
              ),
              Container(width: 16),
              Expanded(
                  child: Container(
                child: Text(
                  "AJAJAJAJ!",
                ),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              )),
            ],
          ),
          RaisedButton.icon(
            autofocus: true,
            label: Text("ZKUS TO OPRAVIT"),
            icon: Icon(Icons.repeat),
            shape: StadiumBorder(),
            onPressed: onBackToLevel,
          ),
          Container(height: 20),
        ],
      ),
    );
  }
}

class OptionsOverlay extends StatelessWidget {
  const OptionsOverlay({
    Key key,
    this.levelInfoText,
    this.showBackground,
    this.onBackToLevel,
    this.onBack,
    this.onRestartLevel,
    this.onDecreaseLevel,
    this.onSwitchBackgroundImage,
    this.canDecreaseLevel = true,
    this.canIncreaseLevel = true,
  }) : super(key: key);

  final VoidCallback onBackToLevel;
  final VoidCallback onBack;
  final VoidCallback onRestartLevel;
  final VoidCallback onDecreaseLevel;
  final VoidCallback onSwitchBackgroundImage;

  /// text (typically number) to show
  final String levelInfoText;

  /// Visibility for image in background
  final bool showBackground;

  /// Whether to show button to decrease level
  final bool canDecreaseLevel;

  /// Whether to show button to increase level
  final bool canIncreaseLevel;

  @override
  Widget build(BuildContext context) {
    removeEditableFocus(context);

    return ShaderOverlay(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: onBackToLevel,
                child: Image.asset(
                  "assets/ada_full_body.png",
                  width: 100,
                ),
              ),
              Container(width: 16),
              Expanded(
                  child: Container(
                child: Text(
                  "JSI NA ÚROVNI $levelInfoText.\n\nCO PRO TEBE MŮŽU UDĚLAT?",
                ),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              )),
            ],
          ),
          Container(height: 0),
          RaisedButton.icon(
            autofocus: true,
            label: Text("NIC, CHCI ZPĚT"),
            icon: Icon(Icons.arrow_back_ios),
            shape: StadiumBorder(),
            onPressed: onBackToLevel,
          ),
          showBackground
              ? RaisedButton.icon(
                  autofocus: true,
                  label: Text("VYPNOUT OBRÁZEK"),
                  icon: Icon(Icons.image),
                  shape: StadiumBorder(),
                  onPressed: onSwitchBackgroundImage,
                )
              : RaisedButton.icon(
                  autofocus: true,
                  label: Text("UKAZOVAT OBRÁZEK"),
                  icon: Icon(Icons.add_photo_alternate),
                  shape: StadiumBorder(),
                  onPressed: onSwitchBackgroundImage,
                ),
          RaisedButton.icon(
            autofocus: true,
            label: Text("VYČISTIT A ZAČÍT ZNOVU"),
            icon: Icon(Icons.refresh),
            shape: StadiumBorder(),
            onPressed: onRestartLevel,
          ),

          /// show only if we can decrease level
          canDecreaseLevel
              ? RaisedButton.icon(
                  label: Text("TO JE MOC TĚŽKÉ, CHCI LEHČÍ"),
                  icon: Icon(Icons.file_download),
                  shape: StadiumBorder(),
                  onPressed: onDecreaseLevel,
                )
              : Container(),
          RaisedButton.icon(
            label: Text("ZPĚT NA VÝBĚR TŘÍDY"),
            icon: Icon(Icons.assignment),
            shape: StadiumBorder(),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

void removeEditableFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
// KeyboardManager.hideKeyboard();
}

/// Overlay widget to be used in [Stack]. Creates shade and container for child padded by 20.
class ShaderOverlay extends StatelessWidget {
  ShaderOverlay({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        color: Color(0xbb000000),
        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
        child: child,
      ),
    );
  }
}

/// type of the task for rendering
enum TriangleTaskType { Pyramid, Funnel, SpiderWeb }

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

class SpiderWeb extends StatelessWidget {
  final Level level;
  final SubmissionController submissionController;
  final bool hint;
  final bool showBackground;

  /// task type to render (RenderType.Pyramid or RenderType.Funnel)
  final TriangleTaskType renderType;

  SpiderWeb(
      {Key key,
        this.level,
        this.submissionController,
        this.hint,
        this.showBackground,
        this.renderType = TriangleTaskType.Funnel})
      : super(key: key);

  static const _tableCellPadding = 16.0;
  final _cellKeys = [GlobalKey(),GlobalKey(),GlobalKey()];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CustomPaint(
          // https://api.flutter.dev/flutter/widgets/CustomPaint-class.html
//              size: Size(200,200),
          painter: showBackground ? SpiderWebPainter() : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Stack(
              children: [
                Text("  1"),

                Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            _tableCellPadding, _tableCellPadding,
                            _tableCellPadding,
                            _tableCellPadding + 15),
                        child: Center(
                          child: Cell(key: _cellKeys[0],
                            value: 0,
                            textController: submissionController.cells[0],
                            masked: !level.solutionMask.mask[0],
                            hint: hint,
                            cellType: CellType.Bubble,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(_tableCellPadding),
                        child: Center(
                          child: Cell(
                            value: 0,
                            textController: submissionController.cells[1],
                            masked: !level.solutionMask.mask[1],
                            hint: hint,
                            cellType: CellType.Bubble,
                          ),
                        ),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(_tableCellPadding),
                            child: Center(
                              child: Cell( key: _cellKeys[1],
                                value: 0,
                                textController: submissionController.cells[2],
                                masked: !level.solutionMask.mask[2],
                                hint: hint,
                                cellType: CellType.Bubble,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(_tableCellPadding),
                            child: Center(
                              child: Cell(
                                value: 0,
                                textController: submissionController.cells[2],
                                masked: !level.solutionMask.mask[2],
                                hint: hint,
                                cellType: CellType.Bubble,
                              ),
                            ),
                          )
                        ])
                    ,
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(_tableCellPadding),
                        child: Center(
                          child: Cell(
                            value: 0,
                            textController: submissionController.cells[2],
                            masked: !level.solutionMask.mask[2],
                            hint: hint,
                            cellType: CellType.Box,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(_tableCellPadding),
                        child: Center(
                          child: Cell(
                            value: 0,
                            textController: submissionController.cells[2],
                            masked: !level.solutionMask.mask[2],
                            hint: hint,
                            cellType: CellType.Box,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(_tableCellPadding),
                        child: Center(
                          child: Cell(
                            value: 0,
                            textController: submissionController.cells[2],
                            masked: !level.solutionMask.mask[2],
                            hint: hint,
                            cellType: CellType.Box,
                          ),
                        ),
                      )
                    ])
                    ,
                  ],
                ),
                DependentWidget(from: _cellKeys[0], to:_cellKeys[1], onPostFrame: () {


                }),
              ],
            )
            ,
          ),
        ),
      ),
    );
  }
}

class DependentWidget extends StatefulWidget{
  final Function onPostFrame;
  final GlobalKey from;
  final GlobalKey to;

  const DependentWidget({Key key, this.from, this.to,this.onPostFrame, }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DependentWidgetState(from,to,onPostFrame);
  }

}

class LayoutParams {
  final Offset offset;
  final Size size;

  LayoutParams(this.offset, this.size);
  LayoutParams.zero() : this(
      Offset.zero,
      Size.zero,
  );

}

class _DependentWidgetState extends State<StatefulWidget>  {

  final GlobalKey from;
  final GlobalKey to;
  final Function onPostFrame;

  LayoutParams _fromLP;
  LayoutParams _toLP;

  String _text = "OLEEEEEEEEEEE";

  _DependentWidgetState(this.from,this.to,this.onPostFrame);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onPostFrameState);
  }


  onPostFrameState(_) {
    setState(() {
      _toLP = getLayoutParams(to);
      _fromLP = getLayoutParams(from);
      _text = "-to:${_toLP.size} ${_toLP.offset}\n-from:${_fromLP.size} ${_fromLP.offset} ";
    });

  }

  LayoutParams getLayoutParams(GlobalKey key) {
    var depBox = key.currentContext?.findRenderObject() as RenderBox;
    if (depBox != null && depBox.hasSize) {
      return LayoutParams(getChildOffset(depBox), depBox.size);
    }else return LayoutParams.zero();
  }

  Offset getChildOffset(RenderBox depBox) => findRenderBox(this).globalToLocal(depBox.localToGlobal(Offset.zero));

  RenderBox findRenderBox(State<StatefulWidget> widgetState) => (widgetState.context.findRenderObject() as RenderBox);

  var targetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Positioned(left: toCenterX(targetKey), top: toCenterY(targetKey),
      child: Transform.rotate(angle: 0,
          child: SizedBox.fromSize(child: Text(_text,key:targetKey))),
    );
  }

  double toCenterX(GlobalKey<State<StatefulWidget>> targetKey) {
    var targetSize = (targetKey.currentContext?.findRenderObject() as RenderBox)
        ?.size;
    if (targetSize == null) return 0;
    var width = targetSize.width;
    var toLPCenterX = _toLP.offset.dx + _toLP.size.width / 2;
    var fromLPCenterX = _fromLP.offset.dx + _fromLP.size.width / 2;
    var cx = (toLPCenterX + fromLPCenterX )/ 2 - width / 2;
    return cx;
  }

  double toCenterY(GlobalKey<State<StatefulWidget>> targetKey) {
    var targetSize = (targetKey.currentContext?.findRenderObject() as RenderBox)
        ?.size;
    if (targetSize == null) return 0;
    var height = targetSize.height;
    var toLPCenterY = _toLP.offset.dy + _toLP.size.height / 2;
    var fromLPCenterY = _fromLP.offset.dy + _fromLP.size.height / 2;
    var cy = (toLPCenterY + fromLPCenterY) / 2 - height / 2;
    return cy;
  }
}



enum ArrowDirection {
  Up,
  Down,
  Right,
  Left,
  UpRight,
  UpLeft,
  DownRight,
  DownLeft,
}

abstract class SpiderWebShape{
}

class TriangleWithCenter extends SpiderWebShape{}
class SquareWithCenter extends SpiderWebShape{}
class Grid extends SpiderWebShape{
  final width;
  final height;

  Grid(this.width, this.height);
}

class SpiderWebPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

