import 'package:cvicebnice/tasksregister.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

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
      title: 'EduKids.cz: Matika do kapsy',
      theme: ThemeData(
        textTheme: GoogleFonts.mcLarenTextTheme(),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xffa02b5f),
          textTheme: ButtonTextTheme.primary,
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        ),
        appBarTheme: AppBarTheme(
            textTheme: GoogleFonts.mcLarenTextTheme(
              Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.white, displayColor: Colors.white),
            ),
            color: Color(0xff2b9aa0)),
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
      extendBody: true,
//      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.chalkboardTeacher),
            onPressed: () {},
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("EduKids.cz / Matika do kapsy"),
//            Text("(prototyp)"),
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
//        shape: ShapeBorder(),

//        bottom: PreferredSize(
//          preferredSize: Size.fromHeight(56),
//          child: AppTaskBar(taskSelectedIndex: taskSelectedIndex),
//        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffa02b5f),
        mini: false,
        tooltip: "Procvičit",
        elevation: 4,
        child: FaIcon(
          FontAwesomeIcons.dumbbell,
        ),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
//                    width: 100,
//                    color: Colors.greenAccent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          color: Colors.white,
                          onPressed: () {
//                  setState(() {
//                    if (levelIndex > 0) levelIndex--;
//                  });
                          },
                        ),
                        Text(567.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          color: Colors.white,
                          onPressed: () {
//                  setState(() {
//                    levelIndex++;
//                  });
                          },
                        ),
                      ],
                    )),
                Container(
//                  width: 80,
//                  color: Colors.deepOrange,
                  child: Row(
                    children: [
                      OutlineButton.icon(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                        ),
                        highlightElevation: 4,
                        textColor: Colors.white,
                        color: Color(0xffa02b5f),
                        icon: Icon(Icons.share, color: Colors.white),
                        label: Text("aeb-3ip"),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          Share.share(
                              "Matika do kapsy: ${tasksRegister[taskSelectedIndex].label} -> "
                              "Kód úlohy: aeb-3ip ( http://matikadokapsy.edukids.cz/ )",
                              subject: "#edukids úloha z matematiky");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//          color: Colors.deepOrange,
        ),
        shape: CircularNotchedRectangle(),
        color: Color(0xff2b9aa0),
      ),
//      bottomNavigationBar: Text(" Všech úrovní: ${tasksRegister.allLevels} "
//          "  Zadání cca: ${tasksRegister.allQuestions}"),
    );
  }
}

//class AppTaskBar extends StatelessWidget {
//  const AppTaskBar({
//    Key key,
//    @required this.taskSelectedIndex,
//  }) : super(key: key);
//
//  final int taskSelectedIndex;
//
//  @override
//  Widget build(BuildContext context) {
//    int levelIndex = 999;
//    return Expanded(
//      child: DefaultTextStyle(
//        style: TextStyle(color: Colors.white),
//        child: Container(
//          color: Color(0xffa02b5f),
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: [
////                    Container(
////                      decoration: BoxDecoration(
////                        borderRadius: BorderRadius.all(Radius.circular(6)),
////                        color: Colors.white,
////                      ),
////                      child: Image.asset(
////                        tasksRegister[taskSelectedIndex].imageAssetName,
////                        width: 48,
////                      ),
////                    ),
////                    Text(tasksRegister[taskSelectedIndex].label),
//              Row(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.remove_circle_outline),
//                    color: Color(0xff2ba06b),
//                    onPressed: () {
////                  setState(() {
////                    if (levelIndex > 0) levelIndex--;
////                  });
//                    },
//                  ),
//                  SizedBox(
//                    width: 48,
//                    child: Text(levelIndex.toString(),
//                        textAlign: TextAlign.center,
//                        style: Theme.of(context).textTheme.headline6),
//
////                    child: TextField(
////                      style: Theme.of(context).textTheme.title,
////                      textAlign: TextAlign.end,
////                      controller: levelFieldController,
////                      keyboardType: TextInputType.number,
////                      onSubmitted: (text) {
////                        setState(() {
////                          levelIndex = int.parse(text);
////                        });
////                      },
////                    ),
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.add_circle_outline),
//                    color: Color(0xff2ba06b),
//                    onPressed: () {
////                  setState(() {
////                    levelIndex++;
////                  });
//                    },
//                  ),
//                ],
//              ),
//
////              Text("#999"),
//              RaisedButton.icon(
//                icon: Icon(Icons.share),
//                label: Text("aeb-3ip"),
//                onPressed: () {
//                  Share.share(
//                      "Matika do kapsy: ${tasksRegister[taskSelectedIndex].label} -> "
//                      "Kód úlohy: aeb-3ip ( http://matikadokapsy.edukids.cz/ )",
//                      subject: "#edukids úloha z matematiky");
//                },
//              ),
//              RaisedButton.icon(
//                icon: FaIcon(FontAwesomeIcons.dumbbell),
//                label: Text("Procvičit"),
//                onPressed: () {},
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
