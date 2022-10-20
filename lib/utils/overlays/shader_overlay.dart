import 'package:flutter/material.dart';

/// Overlay widget to be used in [Stack]. Creates shade and container
/// for child padded by 20.
class ShaderOverlay extends StatelessWidget {
  const ShaderOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        color: const Color(0xbb000000),
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
