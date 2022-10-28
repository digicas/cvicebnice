import 'package:flutter/material.dart';
import 'package:pyramid_funnel_levels/models/level/level.dart';
import 'package:pyramids_funnels/models/cell_type.dart';
import 'package:pyramids_funnels/models/level_type.dart';
import 'package:pyramids_funnels/models/submission_controller.dart';
import 'package:pyramids_funnels/painters/funnel_painter.dart';
import 'package:pyramids_funnels/painters/pyramid_painter.dart';
import 'package:pyramids_funnels/widgets/cell.dart';

class Task extends StatelessWidget {
  const Task({
    super.key,
    required this.level,
    required this.submissionController,
    required this.hint,
    this.showBackground = true,
    this.renderType = TriangleLevelType.funnel,
    this.onSelected,
    this.focusedIndex,
  });
  final Level level;
  final SubmissionController submissionController;
  final bool hint;
  final bool showBackground;

  /// task type to render (RenderType.Pyramid or RenderType.Funnel)
  final TriangleLevelType renderType;

  final void Function(int)? onSelected;
  final int? focusedIndex;

  @override
  Widget build(BuildContext context) {
//    log(level);

    const rowStartIndex = [null, 0, 1, 3, 6, 10];

    final renderRows = <Widget>[];

    for (var row = 1; row <= level.solutionRows; row++) {
      final cells = <Cell>[];

      for (var i = rowStartIndex[row]!; i < rowStartIndex[row]! + row; i++) {
        cells.add(
          Cell(
            value: submissionController.cells[i],
            masked: !level.solutionMask.mask[i],
            onSelected: () {
              if (!level.solutionMask.mask[i]) onSelected?.call(i);
            },
            isFocused: focusedIndex == i,
            hint: hint,
            cellType: renderType == TriangleLevelType.funnel
                ? CellType.bubble
                : CellType.box,
          ),
        );
      }

      if (renderType == TriangleLevelType.funnel) {
        // INSERT row for funnel rendering
        renderRows.insert(
          0,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: cells,
          ),
        );
      }

      if (renderType == TriangleLevelType.pyramid) {
        // ADD row for pyramid rendering
        renderRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: cells,
          ),
        );
      }
    } // end for loop build rows

    if (renderType == TriangleLevelType.funnel) {
      return Center(
        child: Container(
//              color: Color(0xff9C4D82),
          padding: const EdgeInsets.fromLTRB(0, 64, 0, 0),
          child: CustomPaint(
            painter: showBackground ? FunnelPainter() : null,
            child: Padding(
              padding: EdgeInsets.zero,
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

    /// render pyramid
    return Stack(
      children: <Widget>[
        Center(
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
      ],
    );
  }
}
