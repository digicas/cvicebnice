import 'package:flutter/material.dart';
import 'package:pyramid_funnel_levels/models/level_tree/level_tree.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pyramids_funnels/painters/pyramid_painter.dart';

Widget getLevelPreviewPyramid(int levelIndex) {
  final level = LevelTree.getLevelByLevelIndex(levelIndex);
  if (level == null) {
    return const FaIcon(
      FontAwesomeIcons.handshakeAngle,
      size: 48,
    );
  }
  level.generate();

  const rowStartIndex = [null, 0, 1, 3, 6, 10];
  final renderRows = <Widget>[];

  for (var row = 1; row <= level.solutionRows; row++) {
    final cells = <Widget>[];

    for (var i = rowStartIndex[row]!; i < rowStartIndex[row]! + row; i++) {
      final masked = !level.solutionMask.mask[i];
      final value = level.solution[i];
      cells.add(
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 30,
            height: 20,
            decoration: BoxDecoration(
              color: masked ? Colors.grey[200] : Colors.grey[400],
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
              boxShadow: !masked
                  ? []
                  : [
                      const BoxShadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(2, 2),
                      ),
                    ],
            ),
            child: Center(
              child: !masked
                  ? Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      );
    }

    renderRows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: cells,
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(4),
    child: Center(
      child: CustomPaint(
        painter: PyramidPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: renderRows,
        ),
      ),
    ),
  );
}
