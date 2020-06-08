import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'screen.dart';
import 'triangle_levels.dart';

/// Generates the preview Widget for the pyramid task type
///
/// Reflects the size constraint of 150x200
Widget getLevelPreviewPyramid(int levelIndex) {
  var level = LevelTree.getLevelByLevelIndex(levelIndex);
  if (level == null) return FaIcon(FontAwesomeIcons.handsHelping, size: 48);
  level.generate();

  const List<int> _rowStartIndex = [null, 0, 1, 3, 6, 10];
  List<Widget> renderRows = [];

  for (int row = 1; row <= level.solutionRows; row++) {
    List<Widget> cells = [];

    for (int i = _rowStartIndex[row]; i < _rowStartIndex[row] + row; i++) {
      var masked = !level.solutionMask.mask[i];
      var value = level.solution[i];
      cells.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 30,
          height: 20,
          decoration: BoxDecoration(
            color: masked ? Colors.grey[200] : Colors.grey[400],
            border: Border.all(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(4),
              boxShadow: !masked
                  ? []
                  : [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: Offset(2.0, 2.0),
                ),
              ]
          ),
          child: Center(
            child: !masked
                ? Text("$value", style: TextStyle(fontSize: 12))
                : Container(),
          ),
        ),
      ));
    }

    renderRows.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: cells,
    ));
  }

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Center(
      child: Container(
        child: CustomPaint(
          painter: PyramidPainter(),
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
