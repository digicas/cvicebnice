import 'package:flutter/material.dart';
import '../widgets/fluid_slider.dart';

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
    Key key,
    this.onPlay,
    this.onCheckLevelExists,
    this.onSchoolClassToLevelIndex,
  }) : super(key: key);

  /// Callback function when "Start" button is pressed
  final void Function(int levelIndex) onPlay;

  /// Callback function for checking whether level with int index exists
  ///
  /// Shall return true if exists or false if not
  final bool Function(int levelIndex) onCheckLevelExists;

  /// Callback function to get the level index based on school year and month
  final int Function(int schoolYear, int schoolMonth) onSchoolClassToLevelIndex;

  @override
  _LevelSelectState createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  double schoolYear = 1;
  double schoolMonth = 0;
  int levelIndex = 0;

  TextEditingController levelFieldController;

  @override
  void initState() {
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
              child: FluidSlider(
                sliderColor: Color(0xff2ba06b),
                value: schoolYear,
                onChanged: (double newValue) {
                  setState(() {
                    schoolYear = newValue;
                    levelIndex = widget.onSchoolClassToLevelIndex(
                        schoolYear.toInt(), schoolMonth.toInt());
                  });
                },
                min: 1.0,
                max: 5.0,
              ),
            ),
            Container(
              height: 24,
            ),
            ListTile(
              title: Text("Měsíc ve školním roce",
                  style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: FluidSlider(
                sliderColor: Color(0xff2ba06b),
                value: schoolMonth,
                onChanged: (double newValue) {
                  setState(() {
                    schoolMonth = newValue;
                    levelIndex = widget.onSchoolClassToLevelIndex(
                        schoolYear.toInt(), schoolMonth.toInt());
                  });
                },
                mapValueToString: (double value) {
                  return schoolMonths[value.toInt()];
                },
                min: 0.0,
                max: 9.0,
                start: Text(schoolMonths.first,
                    style: _fluidSliderTextStyle(context)),
                end: Text(schoolMonths.last,
                    style: _fluidSliderTextStyle(context)),
                valueTextStyle: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Container(
              height: 24,
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              leading: widget.onCheckLevelExists(levelIndex)
                  ? Icon(Icons.assignment_turned_in)
                  : Icon(Icons.block),
              title:
                  Text("Úroveň:", style: Theme.of(context).textTheme.headline6),
//              trailing: Text("$levelIndex", style: Theme.of(context).textTheme.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    color: Color(0xff2ba06b),
                    onPressed: () {
                      setState(() {
                        if (levelIndex > 0) levelIndex--;
                      });
                    },
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(levelIndex.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6),

//                    child: TextField(
//                      style: Theme.of(context).textTheme.title,
//                      textAlign: TextAlign.end,
//                      controller: levelFieldController,
//                      keyboardType: TextInputType.number,
//                      onSubmitted: (text) {
//                        setState(() {
//                          levelIndex = int.parse(text);
//                        });
//                      },
//                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    color: Color(0xff2ba06b),
                    onPressed: () {
                      setState(() {
                        levelIndex++;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 24,
            ),
            SizedBox(
              height: 62,
//              width: 180,
              child: RaisedButton.icon(
                icon: Icon(
                  Icons.play_circle_outline,
                  size: 40,
                ),
//                color: Colors.blue,
                onPressed: widget.onCheckLevelExists(levelIndex)
                    ? () {
                        widget.onPlay(levelIndex);
                      }
                    : null,
                label: Text("Procvičit", style: TextStyle(fontSize: 28)),
              ),
            ),
            Container(
              height: 32,
            ),
          ]),
    );
  }

  TextStyle _fluidSliderTextStyle(BuildContext context) =>
      Theme.of(context).accentTextTheme.subtitle2;
}

/// Row enabling choosing the level: (-) 789 (+)
class LevelNumberSelector extends StatelessWidget {
  /// Current level number to be rendered
  final int levelIndex;

  /// Callback with updated level number
  final Function(int newIndex) onIndexChange;

  const LevelNumberSelector({
    Key key,
    this.levelIndex = 789,
    @required this.onIndexChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 12),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              color: Colors.white,
              onPressed: () {
                onIndexChange((levelIndex > 0) ? levelIndex-1 : 0);
              },
            ),
            Text(
              levelIndex.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              color: Colors.white,
              onPressed: () {
                onIndexChange(levelIndex+1);
              },
            ),
          ],
        ));
  }
}

