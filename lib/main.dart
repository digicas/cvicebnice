import 'dart:math';

import 'package:flutter/material.dart';

//import 'package:flutter_linkify/flutter_linkify.dart';

import 'tasks/pyramidsandfunnels/task.dart' as pyramidsAndFunnels;

import './screens/level_select.dart';

import 'tasks/pyramidsandfunnels/triangle_levels.dart';

import 'tasks/additions/task.dart' as addition;

//import 'package:pyramida/widgets/launchurl.dart';
//import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // dev banner on/off
      title: 'EduKids: Matika do kapsy',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xffa02b5f),
          textTheme: ButtonTextTheme.primary,
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        ),
        appBarTheme: AppBarTheme(color: Color(0xff2b9aa0)),
//        primarySwatch: Color.fromRGBO(160, 43, 95, 1),
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskSelectionItem {
  final String imageAssetName;
  final String text;

  TaskSelectionItem(this.imageAssetName, this.text);
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Togglebuttons current selection - tasks list
  int taskSelectedIndex;

  final List<TaskSelectionItem> taskCollection = [
    TaskSelectionItem("assets/menu_pyramid.png", "Pyramidy"),
    TaskSelectionItem("assets/menu_funnel.png", "Trychtýř"),
    TaskSelectionItem("assets/menu_additions.png", "Sčítání"),
    TaskSelectionItem("assets/menu_subtractions.png", "Odčítání"),
  ];

  @override
  void initState() {
    // set the togglebuttons for task selection
    taskSelectedIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int mm = LevelTree.levels.fold(0, (p, e) => p + e.masksAmount);
    int totalTasks = LevelTree.levels.fold(
        0,
        (p, e) =>
            p +
            e.masksAmount *
                (pow((e.maxTotal ~/ (e.solutionRows - 1)), e.solutionRows)));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("EduKids.cz / Matika do kapsy"),
            Text("(prototyp)"),
//            Linkify(text: "www.edukids.cz"),
//            GestureDetector(
//                behavior: HitTestBehavior.translucent,
//                onTap: () async {
//                  await launchURL("https://www.edukids.cz");
//                },
//                child: Text(
//                  "EduKids",
//                  style: TextStyle(color: Color(0xffeeeeee)),
//                )),
          ],
        ),
      ),

      body: SafeArea(
        child: Container(
//          color: Colors.pink,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Úloha",
                      style: Theme.of(context).textTheme.headline6),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    children: List.generate(
                      taskCollection.length,
                      (index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            taskCollection[index].imageAssetName,
//                            "assets/menu_pyramid.png",
                            width: 128,
                          ),
//                          Text("Pyramidy"),
                          Text(taskCollection[index].text),
                          Container(height: 8),
                        ],
                      ),
                    ),
                    onPressed: (int index) {
                      setState(() {
                        taskSelectedIndex = index;
                      });
                    },
                    isSelected: List.generate(
                        taskCollection.length, (i) => (i == taskSelectedIndex)),
                  ),
                ),
                LevelSelect(
                  onCheckLevelExists: (index) =>
                      LevelTree.getLevelByLevelIndex(index) == null,
                  onSchoolClassToLevelIndex: (schoolYear, schoolMonth) =>
                      LevelTree.schoolClassToLevelIndex(
                          schoolYear.toInt(), schoolMonth.toInt()),
                  onPlay: (int selectedLevelIndex) {
                    print("selected level $selectedLevelIndex");
                    // if level not yet implemented, just Toast

                    var level =
                        LevelTree.getLevelByLevelIndex(selectedLevelIndex);

                    if (level == null) {
// must use builder function
//                Scaffold.of(context).showSnackBar(SnackBar(
//                  content: Text(
//                      "Úroveň $selectedLevelIndex není ještě naimplemetovaná."),
//                ));

                    } else {
                      Navigator.push(
                        context,
                        // Open task screen
                        MaterialPageRoute(builder: (context) {
                          if (taskSelectedIndex == 2) {
                            return addition.TaskScreen(selectedLevelIndex: 146,);
                          }

                          return pyramidsAndFunnels.TaskScreen(
                            level: level,
                            taskType: (taskSelectedIndex == 0)
                                ? pyramidsAndFunnels.TriangleTaskType.Pyramid
                                : pyramidsAndFunnels.TriangleTaskType.Funnel,
                          );
                        }
//
                            ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Text(
          " Úrovní: ${LevelTree.levels.length} Masek: $mm Zadání cca: $totalTasks"),
    );
  }
}
