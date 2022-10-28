import 'package:flutter/rendering.dart';

class PyramidPainter extends CustomPainter {
  PyramidPainter() {
    _paintL = Paint()
      ..color = const Color(0xFFA88B5A)
      ..style = PaintingStyle.fill;
    _paintR = Paint()
      ..color = const Color(0xFFC0A36B)
      ..style = PaintingStyle.fill;
  }
  late final Paint _paintL;
  late final Paint _paintR;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, _paintL);
    path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, _paintR);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
