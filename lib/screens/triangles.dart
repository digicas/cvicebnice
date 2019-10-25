import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pyramida/models/triangle_levels.dart';
//import 'package:zoom_widget/zoom_widget.dart';

class TaskScreen extends StatefulWidget {
  final Level level;
//  bool maskOn;

  TaskScreen({this.level});
  // { maskOn = false; }

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _maskOn;
  bool _showBackground;
  static const int SHOWBACKGROUND =0;
  static const int MASKON = 1;
  List<bool> _isSelected  = [true, true];

  @override
  void initState() {
//    print("hu $_maskOn");
//    _maskOn ??= true;
//    _showBackground ??= true;
//    _isSelected = [true, false];
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
        title: Text(
            "#${widget.level.levelIndex}: ${widget.level.allMasksToString()}"),
        actions: <Widget>[

          ToggleButtons(
            color: Colors.grey[800],
            selectedColor: Colors.white,
            fillColor: Colors.lightBlueAccent,
            children: <Widget>[
              Icon(Icons.image),
              Icon(Icons.pageview),
            ],
            onPressed: (int index) {
              setState(() {
                _isSelected[index] = !_isSelected[index];
              });
            },
            isSelected: _isSelected,
          ),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  widget.level.regenerate();
                });
              }),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          child: Center(
            child: Funnel(level: widget.level, maskOn: _isSelected[MASKON], showBackground: _isSelected[SHOWBACKGROUND]),
          ),
        ),
      ),
      bottomNavigationBar: Text(widget.level.toString()),
    );
  }
}

class Funnel extends StatelessWidget {
  final Level level;
  final bool maskOn;
  final bool showBackground;
  Funnel({Key key, this.level, this.maskOn, this.showBackground}) : super(key: key);

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
            maskOn: maskOn));
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
  final bool maskOn;
  Cell({Key key, @required this.value, this.masked = false, this.maskOn})
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
            (this.maskOn && this.masked) ? "" : value.toString(),
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
