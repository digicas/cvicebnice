import 'package:flutter/material.dart';
import '../models/addition_levels.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xaabbccdd),
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
