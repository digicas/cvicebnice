import 'package:cvicebnice/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final List<String> schoolMonths = [
  "Září",
  "Říjen",
  "Listopad",
  "Prosinec",
  "Leden",
  "Únor",
  "Březen",
  "Duben",
  "Květen",
  "Červen",
];

/// (Sub)screen for level selection
///
/// Calls onPlay callback with selected level index
class LevelSelect extends StatefulWidget {
  const LevelSelect({
    Key? key,
    this.onPlay,
    this.onCheckLevelExists,
    this.onSchoolClassToLevelIndex,
  }) : super(key: key);

  /// Callback function when "Start" button is pressed
  final void Function(int levelIndex)? onPlay;

  /// Callback function for checking whether level with int index exists
  ///
  /// Shall return true if exists or false if not
  final bool Function(int levelIndex)? onCheckLevelExists;

  /// Callback function to get the level index based on school year and month
  final int Function(int schoolYear, int schoolMonth)? onSchoolClassToLevelIndex;

  @override
  _LevelSelectState createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  /// 1..5
  int schoolYear = 1;

  /// 0..9
  double schoolMonth = 0;
  int levelIndex = 0;

  late TextEditingController levelFieldController;

  @override
  void initState() {
    int currentMonth = (DateTime.now().month +3).remainder(12);
    schoolMonth = currentMonth.clamp(0, 9).toDouble();
    levelFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    levelFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    levelFieldController.text = levelIndex.toString();
    return SingleChildScrollView(
      child: Column(
//              mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            ListTile(
              title: Text("Třída ve škole",
                  style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: ToggleButtons(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  constraints: BoxConstraints(minWidth: 48.0, minHeight: 48.0),
                  textStyle: TextStyle(fontSize: 24),
                  children: List.generate(5, (i) => Text("${i + 1}")),
                  onPressed: (index) {
                    setState(() {
                      var newSchoolYear = index + 1;
                      if (schoolYear != newSchoolYear)
                        levelIndex = widget.onSchoolClassToLevelIndex!(
                            newSchoolYear, schoolMonth.toInt());
                      schoolYear = newSchoolYear;
                    });
                    analytics.log("tap", {
                      "tapped": "YearSelection",
                      "where": "selection screen",
                      "purpose": "Select year difficulty",
                      "info": "#${index + 1}",
                    });
                  },
                  isSelected: List.generate(5, (i) => (i == schoolYear - 1)),
                )),
            Container(
              height: 24,
            ),
            ListTile(
              title: Text("Měsíc ve školním roce",
                  style: Theme.of(context).textTheme.headline6),
            ),

            Padding(
//              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              padding: const EdgeInsets.fromLTRB(0,0,16,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
//                  showValueIndicator: ShowValueIndicator.never,
                      ),
                      child: Slider(
                        min: 0,
                        max: 9,
                        divisions: 9,
                        label: schoolMonths[schoolMonth.toInt()],
                        value: schoolMonth,
                        onChanged: (newValue) {
                          setState(() {
                            if (schoolMonth.toInt() != newValue.toInt())
                              levelIndex = widget.onSchoolClassToLevelIndex!(
                                  schoolYear.toInt(), newValue.toInt());
                            schoolMonth = newValue;
                          });
                          analytics.log("tap", {
                            "tapped": "MonthSelection",
                            "where": "selection screen",
                            "purpose": "Select month difficulty",
                            "info": "#$newValue",
                          });

                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 64,
                      child: Text(schoolMonths[schoolMonth.toInt()])),
                ],
              ),
            ),
            Container(
              height: 96,
            ),

          ]),
    );
  }

}

/// Row enabling choosing the level: (-) 789 (+)
///
/// Not used anymore in this form as (-) and (+) are separated Widgets now
class LevelNumberSelector extends StatelessWidget {
  /// Current level number to be rendered
  final int levelIndex;

  /// Callback with updated level number
  final Function(int newIndex) onIndexChange;

  const LevelNumberSelector({
    Key? key,
    this.levelIndex = 789,
    required this.onIndexChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 4),
        NumberDownButton(
          onIndexChange: onIndexChange,
          levelIndex: levelIndex,
        ),
        NumberDialogButton(
          levelIndex: levelIndex,
          onIndexChange: onIndexChange,
        ),
        NumberUpButton(
          onIndexChange: onIndexChange,
          levelIndex: levelIndex,
        ),
      ],
    ));
  }
}

/// Dialog to retrieve the level number
Future enterNumberDialog(BuildContext context, Function onIndexChange) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text("Číslo úrovně:"),
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              cursorColor: Color(0xffa02b5f),
              autocorrect: false,
              maxLength: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
              ),
              onSubmitted: (String str) {
                Navigator.of(context).pop();
                onIndexChange(int.parse(str));
              },
            ),
          ),
        );
      });
}

/// Widget to render the level number and open the Dialog for entering the new one
class NumberDialogButton extends StatelessWidget {
  const NumberDialogButton({
    Key? key,
    this.levelIndex = 789,
    required this.onIndexChange,
  }) : super(key: key);

  /// Current level number to be rendered
  final int? levelIndex;

  /// Callback with updated level number
  final Function(int newIndex) onIndexChange;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () => enterNumberDialog(context, onIndexChange),
      label: Text("#$levelIndex"),
    );

    // ///////////////// InkWell and Text version
//    return InkWell(
//      onTap: () {
//        return enterNumberDialog(context, onIndexChange);
//      },
//      child: Container(
////        width: 50,
//        child: Text(
//          "#$levelIndex",
//          textAlign: TextAlign.center,
//          style: TextStyle(fontSize: 24, color: Colors.white),
//        ),
//      ),
//    );
  }
}

/// IconButton for decreasing number down to 0
class NumberDownButton extends StatelessWidget {
  const NumberDownButton({
    Key? key,
    required this.onIndexChange,
    required this.levelIndex,
  }) : super(key: key);

  /// Callback with updated level number
  final Function(int newIndex) onIndexChange;

  /// Current level number for calculation
  final int? levelIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.remove_circle_outline),
      color: Colors.white,
      onPressed: () {
        onIndexChange((levelIndex! > 0) ? levelIndex! - 1 : 0);
      },
    );
  }
}

/// IconButton for increasing number
class NumberUpButton extends StatelessWidget {
  const NumberUpButton({
    Key? key,
    required this.onIndexChange,
    required this.levelIndex,
  }) : super(key: key);

  /// Callback with updated level number
  final Function(int newIndex) onIndexChange;

  /// Current level number for calculation
  final int? levelIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle_outline),
      color: Colors.white,
      onPressed: () {
        onIndexChange(levelIndex! + 1);
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
    Key? key,
    this.levelXid = "??????",
    required this.onSubmittedXid,
  }) : super(key: key);

  /// Currently shown level xid
  final String levelXid;

  /// Callback with entered task xid
  final Function(String newXid) onSubmittedXid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlineButton(
        borderSide: BorderSide(
          color: Colors.blueGrey,
        ),
        highlightElevation: 4,
        textColor: Colors.white,
        color: Color(0xffa02b5f),
        child:
            Text(levelXid, style: TextStyle(fontSize: 14, color: Colors.white)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return EnterXidDialog(onSubmittedXid: onSubmittedXid);
              });
        },
      ),
    );
  }
}

/// AlertDialog for manual entry of Xid
///
/// Final validation must be done in the callback
class EnterXidDialog extends StatelessWidget {
  const EnterXidDialog({
    Key? key,
    required this.onSubmittedXid,
  }) : super(key: key);

  /// Callback with entered task xid
  final Function(String newXid) onSubmittedXid;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text("Kód úlohy:"),
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
          decoration: InputDecoration(hintText: "abcghi"),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
          cursorColor: Color(0xffa02b5f),
          autocorrect: false,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: TextStyle(
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
