import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pyramida/models/triangle_levels.dart';
import 'package:pyramida/widgets/fluid_slider.dart';

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
  final levelFieldController = TextEditingController();

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
              padding: const EdgeInsets.all(24),
              child: FluidSlider(
                sliderColor: Color(0xff2ba06b),
                value: schoolYear,
                onChanged: (double newValue) {
                  setState(() {
                    schoolYear = newValue;
                    levelIndex = LevelTree.schoolClassToLevelIndex(schoolYear.toInt(), schoolMonth.toInt());
                  });
                },
                min: 1.0,
                max: 7.0,
              ),
            ),
            Container(
              height: 32,
            ),
            ListTile(
              title: Text("Měsíc ve školním roce",
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FluidSlider(
                sliderColor: Color(0xff2ba06b),
                value: schoolMonth,
                onChanged: (double newValue) {
                  setState(() {
                    schoolMonth = newValue;
                    levelIndex = LevelTree.schoolClassToLevelIndex(schoolYear.toInt(), schoolMonth.toInt());
                  });
                },
                mapValueToString: (double value) {
                  List<String> _map = [
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
                  return _map[value.toInt()];
                },
                min: 0.0,
                max: 9.0,
                start: Text("Září"),
                end: Text("Červen"),
                valueTextStyle: Theme.of(context).textTheme.caption,
              ),
            ),
            Container(
              height: 32,
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 42, 0),
              leading: LevelTree.getLevelByLevelIndex(levelIndex) == null
                  ? Icon(Icons.block) : Icon(Icons.assignment_turned_in),
              title: Text("Úroveň:", style: Theme.of(context).textTheme.title),
//              trailing: Text("$levelIndex", style: Theme.of(context).textTheme.title),
              trailing: SizedBox(
                width: 32,
                child: TextField(
                  style: Theme.of(context).textTheme.title,
                  controller: levelFieldController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (text) {setState(() {levelIndex = int.parse(text);});},
                ),
              ),


            ),
            Container(
              height: 32,
            ),
            SizedBox(
              height: 62,
//              width: 180,
              child: RaisedButton.icon(

                icon: Icon(Icons.play_circle_outline, size: 40,),
//                color: Colors.blue,
                onPressed: () {widget.onPlay(levelIndex);},
                label: Text("Procvičit", style: TextStyle(fontSize: 28)),
              ),
            ),
            Container(
              height: 32,
            ),

          ]),
    );
  }
}
