import 'dart:ui';

import 'package:cvicebnice/widgets/launchurl.dart';
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
    return Container(
      padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
//      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
//              isAlwaysShown: true, // raises error
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${tasksRegister[taskSelectedIndex].label}",
//                        "úroveň $levelSelectedIndex",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Divider(),
                    !canPlayLevel
                        ? TextWithLinks(
                            "Ještě není připraveno :( \n\n"
                            "Můžete nám pomoci - na https://www.edukids.cz\n",
                            style: TextStyle(color: Colors.white),
                            linkStyle: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          )
                        : Container(),
                    Text(
                        tasksRegister[taskSelectedIndex]
                            .getLevelDescription(levelSelectedIndex),
                        style: TextStyle(color: Colors.white)),
                    Divider(),
                    Text(canPlayLevel ?
                        tasksRegister[taskSelectedIndex]
                            .getLevelSuitability(levelSelectedIndex) : "",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          SingleChildScrollView(
            child: Container(
              width: 150,
              height: 200,
              color: Color(0xb0ECE6E9),
              child: Center(
                child: tasksRegister[taskSelectedIndex]
                    .getLevelPreview(levelSelectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
