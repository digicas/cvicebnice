import 'package:flutter/rendering.dart';

class FunnelPainter extends CustomPainter {
  FunnelPainter({this.factor = 1}) {
    _paint = Paint()
      ..color = const Color(0xff829c4d)
      ..style = PaintingStyle.fill;
  }
  late final Paint _paint;
  final double factor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(-20 * factor, 8 * factor)
      ..lineTo(size.width + 20 * factor, 8 * factor)
      ..lineTo(size.width / 2 + 30 * factor, size.height - 5 * factor)
      ..lineTo(size.width / 2 + 30 * factor, size.height + 68 * factor)
      ..lineTo(size.width / 2 - 30 * factor, size.height + 48 * factor)
      ..lineTo(size.width / 2 - 30 * factor, size.height - 5 * factor)
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
