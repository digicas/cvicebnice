import 'dart:math';

import 'package:flutter/material.dart';

//import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pyramida/screens/triangles.dart';

import 'package:pyramida/screens/level_select.dart';

import 'package:pyramida/models/triangle_levels.dart';

import 'screens/triangles.dart';

//import 'package:pyramida/widgets/launchurl.dart';
//import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // dev banner on/off
      title: 'Pyramidy / EduKids',
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

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  /// holder for togglebuttons - pyramid or funnel
  List<bool> triangleTaskSelection;

  @override
  void initState() {
    triangleTaskSelection = [true, false, false];
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
            Text("Pyramidy (prototyp)"),
            Text("/EduKids.cz"),
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
                Container(height: 32),
                ToggleButtons(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          "assets/menu_pyramid.png",
                          width: 128,
                        ),
                        Text("Pyramidy"),
                        Container(height: 8),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/menu_funnel.png",
                          width: 128,
                        ),
                        Text("Trychtýř"),
                        Container(height: 8)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/menu_funnel.png",
                          width: 128,
                        ),
                        Text("Pavučina"),
                        Container(height: 8)
                      ],
                    )
                  ],
                  onPressed: (int index) {
                    setState(() {
                      triangleTaskSelection = selectOnlyLast(triangleTaskSelection,index);
                    });
                  },
                  isSelected: triangleTaskSelection,
                ),
                LevelSelect(
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
                        MaterialPageRoute(
                            builder: (context) => TaskScreen(
                                  level: level,
                                  taskType: getTaskType(triangleTaskSelection),
                                )),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),

//      body: Builder(builder: (context) {
//        return SafeArea(
//          child: Container(
////          color: Colors.pink,
//            child: LevelSelect(
//              onPlay: (int selectedLevelIndex) {
//                print("selected level $selectedLevelIndex");
//                // if level not yet implemented, just Toast
//
//                var level = LevelTree.getLevelByLevelIndex(selectedLevelIndex);
//
//                if (level == null) {
//                  Scaffold.of(context).showSnackBar(SnackBar(
//                    content: Text(
//                        "Úroveň $selectedLevelIndex není ještě naimplemetovaná."),
//                  ));
//                } else {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) =>
//                            TaskScreen(level: level)),
//                  );
//                }
//              },
//            ),
//
//          ),
//        );
//      }),
//

      bottomNavigationBar: Text(
          " Úrovní: ${LevelTree.levels.length} Masek: $mm Zadání cca: $totalTasks"),
    );
  }

  TriangleTaskType getTaskType(List<bool> triangleTaskSelection) {
    return {
      0: TriangleTaskType.Pyramid,
      1: TriangleTaskType.Funnel,
      2: TriangleTaskType.SpiderWeb
    }[triangleTaskSelection.indexOf(true)];
  }

  List<bool> selectOnlyLast(List<bool> triangleTaskSelection, int selectedIndex) {
    for (int buttonIndex = 0;
        buttonIndex < triangleTaskSelection.length;
        buttonIndex++) {
      triangleTaskSelection[buttonIndex] =
          buttonIndex == selectedIndex;
    }
    return triangleTaskSelection;
  }
}

// total combinations:
// jen odhad vzhledem k algoritmum generovani
//
//          child: ListView(
//            children: levels
//                .map(
//                  (level) => ListTile(
//                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute( builder: (context) => TaskScreen(level: level)),
//                      );
//                    },
//                    leading: Text(level.levelIndex.toString()),
//                    title: Text("${level.allMasksToString()}"),
//                    subtitle: Text("totalmax: ${level.maxTotal}, úrovně ${level.maxRows}"),
//                    trailing: Icon(Icons.navigate_next),
//                  ),
//                )
//                .toList(),
//          ),
