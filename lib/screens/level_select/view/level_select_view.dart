import 'package:cvicebnice/services/analytics.dart';
import 'package:flutter/material.dart';

final List<String> schoolMonths = [
  'Září',
  'Říjen',
  'Listopad',
  'Prosinec',
  'Leden',
  'Únor',
  'Březen',
  'Duben',
  'Květen',
  'Červen',
];

/// (Sub)screen for level selection
///
/// Calls onPlay callback with selected level index
class LevelSelect extends StatefulWidget {
  const LevelSelect({
    super.key,
    required this.onPlay,
    required this.onCheckLevelExists,
    required this.onSchoolClassToLevelIndex,
  });

  /// Callback function when "Start" button is pressed
  final void Function(int levelIndex) onPlay;

  /// Callback function for checking whether level with int index exists
  ///
  /// Shall return true if exists or false if not
  final bool Function(int levelIndex) onCheckLevelExists;

  /// Callback function to get the level index based on school year and month
  final int Function(int schoolYear, int schoolMonth) onSchoolClassToLevelIndex;

  @override
  LevelSelectState createState() => LevelSelectState();
}

class LevelSelectState extends State<LevelSelect> {
  /// 1..5
  int schoolYear = 1;

  /// 0..9
  double schoolMonth = 0;
  int levelIndex = 0;

  late TextEditingController levelFieldController;

  @override
  void initState() {
    final currentMonth = (DateTime.now().month + 3).remainder(12);
    schoolMonth = currentMonth.clamp(0, 9).toDouble();
    levelFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    levelFieldController.dispose();
    super.dispose();
  }

  void resetNumbers() {
    setState(
      () {
        schoolYear = 1;
        final currentMonth = (DateTime.now().month + 3).remainder(12);
        schoolMonth = currentMonth.clamp(0, 9).toDouble();
        levelFieldController = TextEditingController();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    levelFieldController.text = levelIndex.toString();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text(
              'Třída ve škole',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: ToggleButtons(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              textStyle: const TextStyle(fontSize: 24),
              onPressed: (index) {
                setState(() {
                  final newSchoolYear = index + 1;
                  if (schoolYear != newSchoolYear) {
                    levelIndex = widget.onSchoolClassToLevelIndex(
                      newSchoolYear,
                      schoolMonth.toInt(),
                    );
                    schoolYear = newSchoolYear;
                  }
                });
                Analytics.log('tap', {
                  'tapped': 'YearSelection',
                  'where': 'selection screen',
                  'purpose': 'Select year difficulty',
                  'info': '#${index + 1}',
                });
              },
              isSelected: List.generate(5, (i) => i == schoolYear - 1),
              children: List.generate(5, (i) => Text('${i + 1}')),
            ),
          ),
          Container(
            height: 24,
          ),
          ListTile(
            title: Text(
              'Měsíc ve školním roce',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
//              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SliderTheme(
                    data: const SliderThemeData(
//                  showValueIndicator: ShowValueIndicator.never,
                        ),
                    child: Slider(
                      max: 9,
                      divisions: 9,
                      label: schoolMonths[schoolMonth.toInt()],
                      value: schoolMonth,
                      onChanged: (newValue) {
                        setState(() {
                          if (schoolMonth.toInt() != newValue.toInt()) {
                            levelIndex = widget.onSchoolClassToLevelIndex(
                              schoolYear,
                              newValue.toInt(),
                            );
                            schoolMonth = newValue;
                          }
                        });
                        Analytics.log('tap', {
                          'tapped': 'MonthSelection',
                          'where': 'selection screen',
                          'purpose': 'Select month difficulty',
                          'info': '#$newValue',
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    schoolMonths[schoolMonth.toInt()],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 96,
          ),
        ],
      ),
    );
  }
}

/// Dialog to retrieve the level number
Future<void> enterNumberDialog(
  BuildContext context,
  int Function(int) onIndexChange,
  int maxIndex,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text('Číslo úrovně:'),
        content: Container(
          decoration: BoxDecoration(
//                      color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 100,
          width: 300,
          child: TextField(
//                controller: TextEditingController()
//                  ..text = levelIndex.toString(), // providing the current value
            // current value is not desired now as user wants to jump elsewhere
            autofocus: true,
            enableInteractiveSelection: true,
            keyboardType: TextInputType.number,
//                decoration: InputDecoration(hintText: "999"),
            // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            cursorColor: const Color(0xffa02b5f),
            autocorrect: false,
            maxLength: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
            ),
            onSubmitted: (String str) {
              Navigator.of(context).pop();
              final index = int.tryParse(str) ?? maxIndex;
              onIndexChange(index > maxIndex ? maxIndex : index);
            },
          ),
        ),
      );
    },
  );
}

/// Widget to render the level number and open the Dialog for entering
/// the new one
class NumberDialogButton extends StatelessWidget {
  const NumberDialogButton({
    super.key,
    this.levelIndex = 789,
    required this.onIndexChange,
    required this.maxIndex,
  });

  /// Current level number to be rendered
  final int levelIndex;

  final int maxIndex;

  /// Callback with updated level number
  final int Function(int newIndex) onIndexChange;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () => enterNumberDialog(context, onIndexChange, maxIndex),
      label: Text('#$levelIndex'),
    );

    // ///////////////// InkWell and Text version
  }
}

/// IconButton for decreasing number down to 0
class NumberDownButton extends StatelessWidget {
  const NumberDownButton({
    super.key,
    required this.onIndexChange,
    required this.levelIndex,
  });

  /// Callback with updated level number
  final int Function(int newIndex) onIndexChange;

  /// Current level number for calculation
  final int levelIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.remove_circle_outline),
      color: Colors.white,
      onPressed: () {
        onIndexChange((levelIndex > 0) ? levelIndex - 1 : 0);
      },
    );
  }
}

/// IconButton for increasing number
class NumberUpButton extends StatelessWidget {
  const NumberUpButton({
    super.key,
    required this.onIndexChange,
    required this.levelIndex,
    required this.maxIndex,
  });

  /// Callback with updated level number
  final int Function(int newIndex) onIndexChange;

  /// Current level number for calculation
  final int levelIndex;

  final int maxIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      color: Colors.white,
      onPressed: () {
        if (levelIndex > maxIndex) return;
        onIndexChange(levelIndex + 1);
      },
    );
  }
}

/// Selector Widget for xids including AlertDialog for manual entering
///
/// Final validation must be done in the callback
/// Currently not used as Xids dialog is initiated otherwise
class LevelXidSelector extends StatelessWidget {
  const LevelXidSelector({
    super.key,
    this.levelXid = '??????',
    required this.onSubmittedXid,
  });

  /// Currently shown level xid
  final String levelXid;

  /// Callback with entered task xid
  final int Function(String newXid) onSubmittedXid;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xffa02b5f),
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        side: const BorderSide(
          color: Colors.blueGrey,
        ),
        elevation: 4,
      ),
      child: Text(
        levelXid,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return EnterXidDialog(onSubmittedXid: onSubmittedXid);
          },
        );
      },
    );
  }
}

/// AlertDialog for manual entry of Xid
///
/// Final validation must be done in the callback
class EnterXidDialog extends StatelessWidget {
  const EnterXidDialog({
    super.key,
    required this.onSubmittedXid,
  });

  /// Callback with entered task xid
  final int? Function(String newXid) onSubmittedXid;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text('Kód úlohy:'),
      content: Container(
        decoration: BoxDecoration(
//                      color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 100,
        width: 300,
        child: TextField(
          autofocus: true,
          enableInteractiveSelection: true,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(hintText: 'abcghi'),
          // inputFormatters:
          // [WhitelistingTextInputFormatter(RegExp('[a-zA-Z]'))],
          cursorColor: const Color(0xffa02b5f),
          autocorrect: false,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
          ),
          onSubmitted: (String str) {
            Navigator.of(context).pop();
            onSubmittedXid(str);
          },
        ),
      ),
    );
  }
}
