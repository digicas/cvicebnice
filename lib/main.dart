
import 'package:cvicebnice/tasksregister.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_linkify/flutter_linkify.dart';

import './screens/level_select.dart';

//import '/widgets/launchurl.dart';
//import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
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

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Togglebuttons current selection - tasks list
  int taskSelectedIndex;

  // we use [tasksRegister] List here - imported from tasksregister.dart

  @override
  void initState() {
    // set the togglebuttons for task selection
    taskSelectedIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  title: Text("Prostředí úloh",
                      style: Theme.of(context).textTheme.headline6),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    children: List.generate(
                      tasksRegister.length,
                      (index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            tasksRegister[index].imageAssetName,
                            width: 128,
                          ),
                          Text(tasksRegister[index].label),
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
                        tasksRegister.length, (i) => (i == taskSelectedIndex)),
                  ),
                ),
                LevelSelect(
                  onCheckLevelExists: (index) =>
                      tasksRegister[taskSelectedIndex]
                          .isLevelImplemented(index),
                  onSchoolClassToLevelIndex: (schoolYear, schoolMonth) =>
                      tasksRegister[taskSelectedIndex]
                          .onSchoolClassToLevelIndex(
                              schoolYear.toInt(), schoolMonth.toInt()),
                  onPlay: (int selectedLevelIndex) {
                    print("Selected level to play: $selectedLevelIndex");
                    // if level not yet implemented, just Toast
                    if (!tasksRegister[taskSelectedIndex]
                        .isLevelImplemented(selectedLevelIndex)) {
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
                          return tasksRegister[taskSelectedIndex]
                              .onOpenTaskScreen(selectedLevelIndex);
                        }
//
                            ),
                      );
                    }

                    //////////////////////////
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Text(
          " Všech úrovní: ${tasksRegister.allLevels} "
          "  Zadání cca: ${tasksRegister.allQuestions}"),
    );
  }
}
