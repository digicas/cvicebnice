import 'package:flutter/material.dart';

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({
    super.key,
    this.size = 32,
    this.color = const Color(0xff96365f),
  });

  final double size;
  final Color color;

  @override
  BlinkingCursorState createState() => BlinkingCursorState();
}

class BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: SizedBox(
        height: widget.size,
        child: Container(
          width: 2,
          height: widget.size,
          color: widget.color,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
