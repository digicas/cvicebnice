import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pyramida/models/triangle_levels.dart';
//import 'package:zoom_widget/zoom_widget.dart';

import 'package:pyramida/widgets/virtual_keyboard.dart';
import 'package:flutter/services.dart'; // for virtual keyboard keys definitions

class TaskScreen extends StatefulWidget {
  final Level level;

  TaskScreen({this.level});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _hintOn;
  bool _showBackground;

  @override
  void initState() {
//    print("hu $_maskOn");
    _hintOn ??= false;
    _showBackground ??= true;
    super.initState();
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    print('didUpdateWidget: $this');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Úroveň: ${widget.level.levelIndex}"),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          child: Center(
            child: Funnel(
              level: widget.level,
              hint: _hintOn,
              showBackground: _showBackground,
            ),
          ),
        ),
      ),
      bottomNavigationBar: VirtualKeyboard(
        optionBackground: _showBackground,
        hintSwitch: _hintOn,
        onPressedKey: (LogicalKeyboardKey key) {
          debugPrint("pressed $key");

          if (key.keyId > 0x2f && key.keyId < 0x3a) {
            // entered digit number
            final int digit = key.keyId & 0x0f;
            debugPrint(digit.toString());
          } else if (key == LogicalKeyboardKey.keyR) {
            // reload/erase level
            debugPrint("reload/erase level");
          } else if (key == LogicalKeyboardKey.mediaTrackNext) {
            // next task => regenerate level
            debugPrint("next task");
            setState(() {
              widget.level.regenerate();
            });
          } else if (key == LogicalKeyboardKey.keyF) {
            // focus wanted -> switch off background
            debugPrint("focus wanted -> switch off background");
            setState(() {
              _showBackground = false;
            });
          } else if (key == LogicalKeyboardKey.keyG) {
            // switch on background graphics
            debugPrint("switch on background graphics");
            setState(() {
              _showBackground = true;
            });
          } else if (key == LogicalKeyboardKey.help) {
            // switch off mask (show help)
            debugPrint("switch hint / show help");
            setState(() {
              _hintOn = !_hintOn;
            });
          }
        },
      ),
    );
  }

}

class Funnel extends StatelessWidget {
  final Level level;
  final bool hint;
  final bool showBackground;
  Funnel({Key key, this.level, this.hint, this.showBackground})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    print(level);

    const List<int> _rowStartIndex = [null, 0, 1, 3, 6, 10];

    List<Widget> renderRows = [];

    for (int row = 1; row <= level.solutionRows; row++) {
      List<Cell> cells = [];

      for (int i = _rowStartIndex[row]; i < _rowStartIndex[row] + row; i++) {
        cells.add(Cell(
            value: level.solution[i],
            masked: !level.solutionMask.mask[i],
            hint: hint));
      }

      // insert for funnel
      // add for pyramid
//      renderRows.insert(
//          0,
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: cells,
//          ));

      renderRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: cells,
      ));
    }

    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            child: CustomPaint(
              // https://api.flutter.dev/flutter/widgets/CustomPaint-class.html
//              size: Size(200,200),
              painter: showBackground ? TrianglePainter() : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: renderRows,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


// background painting
class TrianglePainter extends CustomPainter {
  Paint _paintL;
  Paint _paintR;

  TrianglePainter() {
    _paintL = Paint()
      ..color = Color(0xFFA88B5A)
      ..style = PaintingStyle.fill;
    _paintR = Paint()
      ..color = Color(0xFFC0A36B)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, _paintL);
    path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, _paintR);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Cell extends StatelessWidget {
  final int value;
  final bool masked;
  final bool hint;
  Cell({Key key, @required this.value, this.masked = false, this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
//        margin: const EdgeInsets.all(2.0),
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          color: this.masked ? Colors.grey[200] : Colors.grey[400],
          border: Border.all(
            color: Colors.black,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: !this.masked
              ? []
              : [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: Offset(4.0, 4.0),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            (!this.hint && this.masked) ? "" : value.toString(),
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              color: !this.masked ? Colors.black : Colors.black12,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
