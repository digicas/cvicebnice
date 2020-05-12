import 'package:flutter/material.dart';

import '../tasksregister.dart';

/// Pane with description (and ideally preview :) of the particular task level
class DescriptionPane extends StatelessWidget {
  const DescriptionPane({
    Key key,
    @required this.taskSelectedIndex,
    @required this.levelSelectedIndex,
    @required this.canPlayLevel,
  }) : super(key: key);

  final int taskSelectedIndex;
  final int levelSelectedIndex;
  final bool canPlayLevel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
//                        color: Colors.deepOrange,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text(
                  "Prostředí: ${tasksRegister[taskSelectedIndex].label}, "
                      "úrovně $levelSelectedIndex",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              canPlayLevel
                  ? Text(
                  "Vhodné pro xxxx. třídu (květen) a pro yyy. třídu (září).",
                  style: TextStyle(color: Colors.white))
                  : Container(),
              Divider(),
              !canPlayLevel
                  ? Text(
                  "Ještě není připraveno :( \n\n"
                      "Můžete nám pomoci - na www.edukids.cz\n",
                  style: TextStyle(color: Colors.white))
                  : Container(),
              Text(
                  tasksRegister[taskSelectedIndex]
                      .getLevelDescription(levelSelectedIndex),
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
