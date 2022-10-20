// ignore_for_file: prefer_const_constructors

import 'package:cvicebnice/task_register.dart';
import 'package:cvicebnice/widgets/launch_url.dart';
import 'package:flutter/material.dart';

/// Pane with description (and ideally preview :) of the particular task level
class DescriptionPane extends StatelessWidget {
  const DescriptionPane({
    super.key,
    required this.taskSelectedIndex,
    required this.levelSelectedIndex,
    required this.canPlayLevel,
    required this.onHideDescriptionPane,
  });

  /// Currently selected task type index (for labels, etc.)
  final int taskSelectedIndex;

  /// Currently selected level index (for description, etc.)
  final int levelSelectedIndex;

  /// Indicator whether the current level can be practised
  final bool canPlayLevel;

  /// Callback function when drag down is triggered on preview
  final void Function() onHideDescriptionPane;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
//      decoration: BoxDecoration(border: Border(top:
// BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
//              isAlwaysShown: true, // raises error
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasksRegister[taskSelectedIndex].label,
//                        "úroveň $levelSelectedIndex",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Divider(),
                    if (!canPlayLevel)
                      TextWithLinks(
                        'Ještě není připraveno :( \n\n'
                        'Můžete nám pomoci - na https://www.edukids.cz\n',
                        style: TextStyle(color: Colors.white),
                        linkStyle: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    Text(
                      tasksRegister[taskSelectedIndex]
                          .getLevelDescription(levelSelectedIndex),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Divider(),
                    Text(
                      canPlayLevel
                          ? tasksRegister[taskSelectedIndex]
                              .getLevelSuitability(levelSelectedIndex)
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SingleChildScrollView(
            child: GestureDetector(
              onTap: () {},
              // must be defined, otherwise onVerticalDragEnd is // fired
              onVerticalDragEnd: (_) => onHideDescriptionPane(),
              child: Container(
                width: 150,
                height: 200,
                color: const Color(0xb0ECE6E9),
                child: Center(
                  child: tasksRegister[taskSelectedIndex]
                      .getLevelPreview(levelSelectedIndex),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
