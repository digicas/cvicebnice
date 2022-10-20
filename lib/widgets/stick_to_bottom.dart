import 'package:flutter/material.dart';

/// Widget to stick child Widget to bottom of the screen even when keyboard
/// is shown
///
/// Can be used by [BottomAppBar] for the cases with inside [TextField] fields.
/// [BottomAppBar] further requires to reposition notched FAB
///
/// Discussion: https://www.reddit.com/r/FlutterDev/comments/8ao6ty/how_to_make_bottom_appbar_that_sticks_to_the_top/
class StickToBottom extends StatelessWidget {
  const StickToBottom({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: child,
    );
  }
}
