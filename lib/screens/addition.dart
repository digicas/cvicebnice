import 'package:cvicebnice/widgets/small_numeric_keyboard.dart';
import 'package:flutter/material.dart';
import '../models/addition_levels.dart' as model;

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _showBackground;
  bool taskSubmitted;
  bool optionsRequested;

  @override
  void initState() {
//    _level = widget.level;
//    print("hu $_maskOn");
//    _hintOn ??= false;
    _showBackground ??= true;
    taskSubmitted ??= false;
    optionsRequested ??= false;
//    levelInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xffECE6E9),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
                  child: EquationList(),
                ),
              ),
              Container(
                width: double.infinity,
                height: 125,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffECE6E9),
                      Color(0xccECE6E9),
                      Color(0x00ECE6E9),
                    ],
                    begin: FractionalOffset(0,0),
                    end: FractionalOffset(0,1),
                    stops: [0,0.6,1],
                    tileMode: TileMode.clamp,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 20,
                right: 20,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

//                      submissionController.isFilled
                      true
                          ? RaisedButton(
                              shape: StadiumBorder(),
                              child: Text("HOTOVO?"),
                              onPressed: () {
                                setState(() {
                                  /// must hide keyboard before done overlay is shown
                                  removeEditableFocus(context);
                                  taskSubmitted = true;
                                });
                              },
                            )
                          : Container(),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EquationList extends StatelessWidget {
  const EquationList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        Text("4008 + 3548 = 7556"),
      ] + List.generate(50, (index) => Text("Tady budou tasks $index")),

    );
  }
}


//class TaskScreen extends StatefulWidget {
//  final Level level;
////  final TriangleTaskType taskType;
//
//  TaskScreen({this.level});
//
//  @override
//  _TaskScreenState createState() => _TaskScreenState();
//}
//
//
//class _TaskScreenState extends State<TaskScreen> {
//  bool _hintOn;
//  bool _showBackground;
//  bool taskSubmitted;
//  bool optionsRequested;
//  Level _level;
//
////  SubmissionController submissionController;
//
//  @override
//  void initState() {
//    _level = widget.level;
////    print("hu $_maskOn");
//    _hintOn ??= false;
//    _showBackground ??= true;
//    taskSubmitted ??= false;
//    optionsRequested ??= false;
//    levelInit();
//
//    super.initState();
//  }
//
//  void levelInit() {
//    _level.generate();
//    submissionController = SubmissionController(level: _level);
//    submissionController.addListener(_checkSolution);
//    taskSubmitted = false;
//    optionsRequested = false;
//  }
//
//  void levelRegenerate() {
////    submissionController.dispose();
//    levelInit();
////  initState();
//  }
//
//  _checkSolution() {
//    print(
//        "Submission: ${submissionController.toString()} : solved: ${submissionController.isSolved}");
//    setState(() {});
//  }
//
//  @override
//  void dispose() {
//    submissionController.dispose();
//    super.dispose();
//  }
//
//  @override
//  void didUpdateWidget(TaskScreen oldWidget) {
//    print('didUpdateWidget: $this');
//    super.didUpdateWidget(oldWidget);
//  }
//
