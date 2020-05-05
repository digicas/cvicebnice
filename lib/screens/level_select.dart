import 'package:flutter/material.dart';
import '../tasks/pyramidsandfunnels/triangle_levels.dart';
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

class LevelSelect extends StatefulWidget {
  const LevelSelect({
    Key key,
    this.onPlay,
  }) : super(key: key);

  final void Function(int) onPlay;

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
//    levelIndex = LevelTree.schoolClassToLevelIndex(schoolYear.toInt(), schoolMonth.toInt());
    levelFieldController.text = levelIndex.toString();
    return SingleChildScrollView(
      child: Column(
//              mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            ListTile(
              title: Text("Třída ve škole",
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: FluidSlider(
                sliderColor: Color(0xff2ba06b),
                value: schoolYear,
                onChanged: (double newValue) {
                  setState(() {
                    schoolYear = newValue;
                    levelIndex = LevelTree.schoolClassToLevelIndex(
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
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: FluidSlider(
                sliderColor: Color(0xff2ba06b),
                value: schoolMonth,
                onChanged: (double newValue) {
                  setState(() {
                    schoolMonth = newValue;
                    levelIndex = LevelTree.schoolClassToLevelIndex(
                        schoolYear.toInt(), schoolMonth.toInt());
                  });
                },
                mapValueToString: (double value) {
                  return schoolMonths[value.toInt()];
                },
                min: 0.0,
                max: 9.0,
                start: Text(
                    schoolMonths.first, style: _fluidSliderTextStyle(context)),
                end: Text(
                    schoolMonths.last, style: _fluidSliderTextStyle(context)),
                valueTextStyle: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              height: 24,
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              leading: LevelTree.getLevelByLevelIndex(levelIndex) == null
                  ? Icon(Icons.block)
                  : Icon(Icons.assignment_turned_in),
              title: Text("Úroveň:", style: Theme.of(context).textTheme.title),
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
                    width: 32,
                    child: Text(levelIndex.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title),

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
                onPressed: LevelTree.getLevelByLevelIndex(levelIndex) == null
                    ? null
                    : () {
                        widget.onPlay(levelIndex);
                      },
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
      Theme
          .of(context)
          .accentTextTheme
          .subtitle;
}
