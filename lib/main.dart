import 'package:flutter/material.dart';
import 'package:pyramida/screens/triangles.dart';

import 'package:pyramida/models/triangle_levels.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // dev banner on/off
      title: 'Pyramida Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    int mm = levels.fold(0, (p, e) => p + e.masksAmount);

    return Scaffold(
      appBar: AppBar(
        title: Text("Trojúhelníky test"),
      ),
      body: SafeArea(
        child: Container(
//          color: Colors.pink,
          child: ListView(
            children: levels
                .map(
                  (level) => ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute( builder: (context) => TaskScreen(level: level)),
                      );
                    },
                    leading: Text(level.levelIndex.toString()),
                    title: Text("${level.allMasksToString()}"),
                    subtitle: Text("totalmax: ${level.maxTotal}, úrovně ${level.maxRows}"),
                    trailing: Icon(Icons.navigate_next),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      bottomNavigationBar: Text("Levels: ${levels.length} Masks: $mm"),
    );
  }
}
