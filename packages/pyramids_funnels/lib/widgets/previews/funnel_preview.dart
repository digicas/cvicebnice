import 'package:flutter/material.dart';
import 'package:pyramid_funnel_levels/models/level_tree/level_tree.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pyramids_funnels/painters/funnel_painter.dart';

/// Generates the preview Widget for the Funnel task type
/// Reflects the size constraint of 150x200

Widget getLevelPreviewFunnel(int levelIndex) {
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
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color:
                  !masked ? const Color(0xff9C4D82) : const Color(0xffeeeeee),
              border: Border.all(
                color: const Color(0xff9C4D82),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
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
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xffeeeeee),
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      );
    }

    renderRows.insert(
      0,
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
        painter: FunnelPainter(factor: 0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: renderRows,
        ),
      ),
    ),
  );
}
