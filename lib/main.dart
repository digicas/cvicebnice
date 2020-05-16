import 'package:cvicebnice/tasksregister.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

import './screens/level_select.dart';
import 'screens/descriptionpane.dart';
import 'widgets/launchurl.dart';


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
  /// Togglebuttons current selection - tasks list
  int taskSelectedIndex;

  /// Currently selected level index
  int levelSelectedIndex;

  /// Currently selected xid of the particular task level
  String levelXid;

  bool descriptionPaneVisible = false;

  final GlobalKey<ScaffoldState> globalTaskListScaffoldKey =
      GlobalKey<ScaffoldState>();

  // we use [tasksRegister] List here - imported from tasksregister.dart

  @override
  void initState() {
    // set the togglebuttons for task selection
    taskSelectedIndex = 0;
    levelSelectedIndex = 0;
    levelXid = "??????";

    super.initState();
  }

  /// Navigating to the TaskScreen
  void playWithSelectedLevelIndex() {
    print("Selected level to play: $levelSelectedIndex");
    // if level not yet implemented, just Toast
    if (!tasksRegister[taskSelectedIndex]
        .isLevelImplemented(levelSelectedIndex)) {
      print(
          "Cannot practise: $levelSelectedIndex for ${tasksRegister[taskSelectedIndex].label}");
    } else {
      Navigator.push(
        context,
        // Open task screen
        MaterialPageRoute(builder: (context) {
          return tasksRegister[taskSelectedIndex]
              .onOpenTaskScreen(levelSelectedIndex);
        }),
      );
    }
  }

  /// Requests task register whether level exists for the particular task environment
  bool checkLevelExists(int index) =>
      tasksRegister[taskSelectedIndex].isLevelImplemented(index);

  @override
  Widget build(BuildContext context) {
    bool canPlayLevel = checkLevelExists(levelSelectedIndex);
    levelXid = tasksRegister.getWholeXid(taskSelectedIndex, levelSelectedIndex);

    return Scaffold(
      key: globalTaskListScaffoldKey,
      extendBody: true,
//      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: "Matika do kapsy",
              applicationVersion: "20200516",
              applicationIcon: null,
              // TODO add app icon
              applicationLegalese:
                  "Vytvořeno v rámci neziskového projektu EduKids spolkem Kvalitní digičas, z.s. s pomocí přispěvovatelů.",
              children: [
                SizedBox(height: 8),
                Text(
                  "Chceme posilovat vzdělání dětí účinným využitím mobilů a minimalizovat tak digitální konzum.",
//                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 8),
                TextWithLinks("web: https://www.edukids.cz\n"
                    "(f) https://www.facebook.com/EduKids.cz"),
                SizedBox(height: 8),
                TextWithLinks(
                    "Budeme rádi, když nám pomůžete - https://www.edukids.cz/podporte-nas"),
              ],
            );
          },
        ),
//        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.chalkboardTeacher),
            onPressed: () {
              setState(() {
                descriptionPaneVisible = !descriptionPaneVisible;
              });
            },
          ),
        ],
        title: InkWell(
          onTap: () {
            print("jojo");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("EduKids / Matika do kapsy"),
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
        ),
//        shape: ShapeBorder(),

//        bottom: PreferredSize(
//          preferredSize: Size.fromHeight(56),
//          child: AppTaskBar(taskSelectedIndex: taskSelectedIndex),
//        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
              onCheckLevelExists: (index) => checkLevelExists(index),
              onSchoolClassToLevelIndex: (schoolYear, schoolMonth) {
                var newIndex = tasksRegister[taskSelectedIndex]
                    .onSchoolClassToLevelIndex(
                        schoolYear.toInt(), schoolMonth.toInt());
                setState(() {
                  levelSelectedIndex = newIndex;
                });
                return newIndex;
              },
              onPlay: (int selectedLevelIndex) {
                playWithSelectedLevelIndex();
                //////////////////////////
              },
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                height: descriptionPaneVisible ? 256 : 48),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: canPlayLevel ? Color(0xffa02b5f) : Colors.grey,
        mini: !canPlayLevel,
        tooltip: "Procvičit",
        elevation: 4,
        child: canPlayLevel ? FaIcon(FontAwesomeIcons.play) : Icon(Icons.block),
        onPressed: canPlayLevel
            ? () {
                playWithSelectedLevelIndex();
              }
            : null,
      ),
      bottomNavigationBar: BottomAppBar(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          height: descriptionPaneVisible ? 256 : 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LevelNumberSelector(
                      levelIndex: levelSelectedIndex,
                      onIndexChange: (newLevelIndex) {
                        setState(() {
                          levelSelectedIndex = newLevelIndex;
                        });
                      },
                    ),
                    Container(
//                  width: 80,
//                  color: Colors.deepOrange,
                      child: Row(
                        children: [
                          LevelXidSelector(
                            levelXid: levelXid,
                            onSubmittedXid: (newXid) {
                              print(
                                  "Nove xid: # $newXid # pro a) validaci b) prepnuti tasku / levelu / roku a mesicu");
                              var newTaskTypeIndex =
                                  tasksRegister.getTaskTypeIndexFromXid(newXid);
                              print("Task Type index: $newTaskTypeIndex");

                              int newLevelIndex = -1;
                              if (newTaskTypeIndex > -1) {
                                newLevelIndex = tasksRegister[newTaskTypeIndex]
                                    .getLevelIndexFromXid(newXid);
                                print("Task's selected index: $newLevelIndex");
                                setState(() {
                                  taskSelectedIndex = newTaskTypeIndex;
                                  if (newLevelIndex > -1)
                                    levelSelectedIndex = newLevelIndex;
                                });
                              }

                              if (newTaskTypeIndex == -1 ||
                                  newLevelIndex == -1) {
                                print("Show not found dialog");
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        title: Text("Kód $newXid neznám :("),
                                      );
                                    });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              String text =
                                  "https://matikadokapsy.edukids.cz : "
                                  "${tasksRegister[taskSelectedIndex].label} #$levelSelectedIndex -> "
                                  "Kód úlohy: # $levelXid #";
                              if (kIsWeb) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Jak nasdílet vybranou úlohu?"),
                                        content:
                                            Text("Pošlete text:\n\n" + text),
                                        actions: [
                                          FlatButton.icon(
                                            icon: Icon(Icons.content_copy),
                                            label: Text("Zkopírovat"),
                                            onPressed: () {
                                              Clipboard.setData(
                                                      ClipboardData(text: text))
                                                  .then((_) {
                                                Navigator.of(context).pop();
                                                globalTaskListScaffoldKey
                                                    .currentState
                                                    .showSnackBar(SnackBar(
                                                        duration: Duration(
                                                            seconds: 3),
                                                        content: Text(
                                                            "Zkopírováno!")));
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                // Share intents work only on mobile devices
                                Share.share(text,
                                    subject: "#edukids úloha z matematiky");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: DescriptionPane(
                      taskSelectedIndex: taskSelectedIndex,
                      levelSelectedIndex: levelSelectedIndex,
                      canPlayLevel: canPlayLevel),
                ),
              ],
            ),
          ),
//          color: Colors.deepOrange,
        ),
        shape: CircularNotchedRectangle(),
        color: Color(0xff2b9aa0),
      ),
    );
  }
}
