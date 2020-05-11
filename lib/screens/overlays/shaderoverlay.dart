import 'package:flutter/material.dart';

/// Overlay widget to be used in [Stack]. Creates shade and container for child padded by 20.
class ShaderOverlay extends StatelessWidget {
  ShaderOverlay({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        color: Color(0xbb000000),
        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
        child: child,
      ),
    );
  }
}
