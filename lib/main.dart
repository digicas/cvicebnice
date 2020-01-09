import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pyramida/screens/triangles.dart';

import 'package:pyramida/screens/level_select.dart';

import 'package:pyramida/models/triangle_levels.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // dev banner on/off
      title: 'Pyramidy',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xffa02b5f),
          textTheme: ButtonTextTheme.primary,
          colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        ),
        appBarTheme: AppBarTheme(color: Color(0xff2b9aa0)),
//        primarySwatch: Color.fromRGBO(160, 43, 95, 1),
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int mm = levels.fold(0, (p, e) => p + e.masksAmount);
    int totalTasks = levels.fold(0, (p, e) => p + e.masksAmount*(pow((e.maxTotal~/(e.solutionRows-1)), e.solutionRows ) ));

    return Scaffold(
      appBar: AppBar(
        title: Text("Pyramidy (prototyp)"),
      ),
      body: SafeArea(
        child: Container(
//          color: Colors.pink,
          child: LevelSelect(onPlay: (int selectedLevel) {
            print("selected $selectedLevel");

            // if level not yet implemented, just Toast

            print(selectedLevel);



            Navigator.push(context, MaterialPageRoute( builder: (context) => TaskScreen(level: levels[selectedLevel])),
            );
          },),

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
        ),
      ),
      bottomNavigationBar: Text(
          " Implemented levels: ${levels.length} Masks: $mm Zadání cca: $totalTasks"),
    );
  }
}

// total combinations:
// jen level 2 + level 3 => 13*5 *3 masks => 195
//
