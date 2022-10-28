import 'dart:math';

import 'package:cvicebnice/constants.dart';
import 'package:cvicebnice/git_info.g.dart' as git_info;
import 'package:cvicebnice/screens/about/view/about_view.dart';
import 'package:cvicebnice/screens/description_pane/description_pane_screen.dart';
import 'package:cvicebnice/screens/level_select/view/level_select_view.dart';
import 'package:cvicebnice/services/analytics.dart';
import 'package:cvicebnice/services/version_service/version_service.dart';
import 'package:cvicebnice/task_register.dart';
import 'package:cvicebnice/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late int taskSelectedIndex;
  late int levelSelectedIndex;
  late String levelXid;

  bool descriptionPaneVisible = false;

  final globalTasksScreenScaffoldKey = GlobalKey<ScaffoldState>();

  bool isLevelActive(int index) => false;

  final _levelSelectKey = GlobalKey<LevelSelectState>();

  @override
  void initState() {
    taskSelectedIndex = 0;
    levelSelectedIndex = 2;
    levelXid = '??????';
    super.initState();
  }

  /// Updates the index with refreshing the build
  void updateLevelIndex(int newLevelIndex) =>
      setState(() => levelSelectedIndex = newLevelIndex);

  bool checkLevelExists(int index) =>
      tasksRegister[taskSelectedIndex].isLevelImplemented(index);

  void playWithSelectedLevelIndex() {
    // if level not yet implemented, just Toast
    if (!tasksRegister[taskSelectedIndex]
        .isLevelImplemented(levelSelectedIndex)) {
    } else {
      Analytics.log(
        'practice_start',
        {'task': '$levelXid #$levelSelectedIndex'},
      );
      Navigator.push(
        context,
        // Open task screen
        MaterialPageRoute<Widget>(
          builder: (context) {
            return tasksRegister[taskSelectedIndex]
                .onOpenTaskScreen(levelSelectedIndex);
          },
        ),
      );
    }
  }

  void buildLevelByCodeDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => EnterXidDialog(
        onSubmittedXid: (newXid) {
          final newTaskTypeIndex =
              tasksRegister.getTaskTypeIndexFromXid(newXid);

          var newLevelIndex = -1;
          if (newTaskTypeIndex > -1) {
            newLevelIndex =
                tasksRegister[newTaskTypeIndex].getLevelIndexFromXid(newXid);
            setState(() {
              taskSelectedIndex = newTaskTypeIndex;
              if (newLevelIndex > -1) levelSelectedIndex = newLevelIndex;
            });
          }
          Analytics.log(
            'select_content',
            {'content_type': 'task', 'item_id': newXid},
          );

          if (newTaskTypeIndex == -1 || newLevelIndex == -1) {
            showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text('Kód $newXid neznám :('),
                );
              },
            );
          }
          return null;
        },
      ),
    );
  }

  void showShareDialog(
    BuildContext context,
  ) {
    Analytics.log('share', {'content_type': 'task', 'item_id': levelXid});

    final text =
        'https://matikadokapsy.edukids.cz : ${tasksRegister[taskSelectedIndex].label} #$levelSelectedIndex -> Kód úlohy: # $levelXid #';
    if (kIsWeb) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Jak nasdílet vybranou úlohu?'),
            content: Text('Pošlete text:\n\n$text'),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.content_copy),
                label: const Text('Zkopírovat'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text)).then((_) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text('Zkopírováno!'),
                      ),
                    );
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      // Share intents work only on mobile devices
      // !Share
      // Share.share(text, subject: '#edukids úloha z matematiky');
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPlayLevel = checkLevelExists(levelSelectedIndex);
    levelXid = tasksRegister.getWholeXId(taskSelectedIndex, levelSelectedIndex);
    return Scaffold(
      key: globalTasksScreenScaffoldKey,
      extendBody: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight:
                MediaQuery.of(context).size.height - (kPreviewBarHeight + 32),
            pinned: true,
            leading: IconButton(
              onPressed: () => buildAboutDialog(context),
              icon: const Icon(Icons.info_outline),
            ),
            actions: [
              IconButton(
                onPressed: buildLevelByCodeDialog,
                icon: const FaIcon(FontAwesomeIcons.rocket),
              ),
              IconButton(
                onPressed: () => setState(
                  () => descriptionPaneVisible = !descriptionPaneVisible,
                ),
                icon: const FaIcon(FontAwesomeIcons.chalkboardUser),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Matika do kapsy'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  FractionallySizedBox(
                    alignment: const Alignment(-0.8, 0),
                    heightFactor: 0.6,
                    widthFactor: 0.4,
                    child: Image.asset(
                      'assets/ada_full_body.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: const Alignment(0.7, 0),
                    heightFactor: 0.3,
                    widthFactor: 0.4,
                    child: InkWell(
                      onTap: () => buildAboutDialog(context),
                      child: Image.asset(
                        'assets/edukids_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Transform.rotate(
                        angle: -pi / 2,
                        alignment: Alignment.topLeft,
                        child: Text(
                          git_info.shortSHA,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: 8,
                      ),
                      child: InkWell(
                        onTap: versionService.upgrade,
                        child: const SizedBox(
                          width: 24,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                ListTile(
                  title: Text(
                    'Prostředí a typ úloh',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    onPressed: (int index) => setState(() {
                      taskSelectedIndex = index;
                      levelSelectedIndex = levelSelectedIndex = 2;
                      _levelSelectKey.currentState?.resetNumbers();
                    }),
                    isSelected: List.generate(
                      4,
                      (index) => index == taskSelectedIndex,
                    ),
                    children: List.generate(
                      4,
                      (index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            tasksRegister[index].imageAssetName,
                            width: 128,
                          ),
                          Text(tasksRegister[index].label),
                          const SizedBox(height: 8)
                        ],
                      ),
                    ),
                  ),
                ),
                LevelSelect(
                  key: _levelSelectKey,
                  onCheckLevelExists: checkLevelExists,
                  onSchoolClassToLevelIndex: (schoolYear, schoolMonth) {
                    final newIndex = tasksRegister[taskSelectedIndex]
                        .onSchoolClassToLevelIndex(schoolYear, schoolMonth);
                    Analytics.log('select_content', {
                      'content_type': 'year_month',
                      'item_id': '$schoolYear - $schoolMonth'
                    });
                    setState(() {
                      levelSelectedIndex = newIndex;
                    });

                    return newIndex;
                  },
                  onPlay: (int selectedLevelIndex) {
                    playWithSelectedLevelIndex();
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  height: descriptionPaneVisible ? kPreviewBarHeight : 48,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          final fabSize = canPlayLevel
              ? relativeSize(context, 0.145)
              : relativeSize(context, 0.145);

          final fabIconSize = canPlayLevel
              ? relativeSize(context, 0.145 * 0.5)
              : relativeSize(context, 0.145 * 0.5);

          return SizedBox(
            width: fabSize,
            height: fabSize,
            child: FloatingActionButton(
              backgroundColor:
                  canPlayLevel ? const Color(0xffa02b5f) : Colors.grey,
              mini: !canPlayLevel,
              tooltip: 'Procvičit',
              elevation: 2,
              onPressed: canPlayLevel ? playWithSelectedLevelIndex : null,
              child: canPlayLevel
                  ? FaIcon(
                      FontAwesomeIcons.play,
                      size: fabIconSize,
                    )
                  : Icon(
                      Icons.block,
                      size: fabIconSize,
                    ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xff2b9aa0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          height: descriptionPaneVisible ? 256 : 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      // Left side of the bottomBar
                      width: (relativeWidth(context, 0.5)) -
                          (relativeSize(context, kFABSizeRatio) / 2) -
                          4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NumberDialogButton(
                            maxIndex:
                                tasksRegister[taskSelectedIndex].lastIndex,
                            levelIndex: levelSelectedIndex,
                            onIndexChange: (newIndex) {
                              Analytics.log('select_content', {
                                'content_type': 'task_level',
                                'item_id':
                                    '#${levelXid.substring(0, 3)}: $newIndex'
                              });

                              updateLevelIndex(newIndex);
                              return newIndex;
                            },
                          ),
                          NumberDownButton(
                            levelIndex: levelSelectedIndex,
                            onIndexChange: (newIndex) {
                              Analytics.log('tap', {
                                'tapped': 'Minus button',
                                'where': 'selection screen bottombar',
                                'purpose': 'decrease selected level',
                                'info':
                                    '''new level for #${levelXid.substring(0, 3)} : $newIndex''',
                              });

                              updateLevelIndex(newIndex);
                              return newIndex;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      // Right side of the bottom Bar
                      width: (relativeWidth(context, 0.5)) -
                          (relativeSize(context, kFABSizeRatio) / 2) -
                          4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NumberUpButton(
                            levelIndex: levelSelectedIndex,
                            maxIndex:
                                tasksRegister[taskSelectedIndex].levelsCount,
                            onIndexChange: (newIndex) {
                              Analytics.log('tap', {
                                'tapped': 'Plus button',
                                'where': 'selection screen bottombar',
                                'purpose': 'increase selected level',
                                'info':
                                    '''new level for #${levelXid.substring(0, 3)}: $newIndex''',
                              });
                              updateLevelIndex(newIndex);
                              return newIndex;
                            },
                          ),
                          Expanded(
                            // For narrower devices
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ActionChip(
                                label: Text(levelXid),
                                onPressed: () => showShareDialog(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: DescriptionPane(
                    taskSelectedIndex: taskSelectedIndex,
                    levelSelectedIndex: levelSelectedIndex,
                    canPlayLevel: canPlayLevel,
                    onHideDescriptionPane: () {
                      setState(() {
                        Analytics.log('tap', {
                          'tapped': 'Preview pane #ddrag',
                          'where': 'selection bottombar',
                          'purpose': 'hide preview pane',
                          'info': 'drag down to hide',
                        });
                        descriptionPaneVisible = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
