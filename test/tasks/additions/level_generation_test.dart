// import 'package:cvicebnice/data/tasks/pyramid_funnels/triangle_levels.dart';
// import 'package:cvicebnice/tasks/additions/level.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:cvicebnice/tasks/additions/leveltree.dart';

// /// tests using matchers: http://dartdoc.takyam.com/articles/dart-unit-tests/#matchers

import 'dart:developer';

import 'package:cvicebnice/data/tasks/additions/level.dart';
import 'package:cvicebnice/data/tasks/additions/level_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Levels generation',
    () {
      final levelTree = LevelTree();
      test(
        'Generated Values in range',
        () {
          for (final level in levelTree.levels) {
            for (var i = 0; i < 2; i++) {
              level.generate();

              expect(
                level.solution![0],
                inInclusiveRange(
                  level.valueRange[0],
                  level.valueRange[1],
                ),
              );

              expect(
                level.solution![1],
                inInclusiveRange(
                  level.valueRange[0],
                  level.valueRange[1],
                ),
              );

              if ((level.solution?.length ?? 0) > 3) {
                expect(
                  level.solution![1],
                  inInclusiveRange(
                    level.valueRange[0],
                    level.valueRange[1],
                  ),
                );
              }
            }
          }
        },
      );

      test(
        'Levels masks check',
        () {
          for (final level in levelTree.levels) {
            level.generate();
            for (final mask in level.masks) {
              log('${level.index}');
              log('${Level.checkSubmission(level.solution!, [1], mask)}');
              expect(
                () => Level.checkSubmission(level.solution!, [1], mask),
                returnsNormally,
              );
            }
          }
        },
      );

      test(
        'Level school year & month mapping',
        () {
          for (final level in levelTree.levels) {
            expect(
              () => LevelTree.getMinimumSchoolClassAndMonth(level.index),
              returnsNormally,
              reason: '$level.index',
            );
          }
        },
      );

      test(
        'Unique Xids only',
        () {
          final xids = levelTree.levels.map((l) => l.xid);
          final uniqueXids = xids.toSet().toList();
          for (final xid in uniqueXids) {
            expect(
              xids.where((x) => x == xid).length,
              equals(1),
              reason: 'Duplicate xid: $xid',
            );
          }
        },
      );
    },
  );
}
