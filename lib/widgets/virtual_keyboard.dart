import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for virtual keyboard
import 'package:flutter/services.dart'; // for virtual keyboard

class VirtualKeyboard extends StatelessWidget {
  const VirtualKeyboard({
    Key key,
    this.onPressedKey,
    this.optionBackground = true,
    this.hintSwitch = false,
  }) : super(key: key);

  /// The callback that is called when the keyboard is tapped
  final void Function(LogicalKeyboardKey) onPressedKey;
  final bool optionBackground;
  final bool hintSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 2,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                  // submit solution
                  onPressed: () => onPressedKey(LogicalKeyboardKey.enter),
                  child: Icon(Icons.done_outline),
                  color: Colors.greenAccent,
                )),
                Container(
                  width: 8,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit0),
                        child: Text("0"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit1),
                        child: Text("1"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit2),
                        child: Text("2"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit3),
                        child: Text("3"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit4),
                        child: Text("4"))),
                Container(
                  width: 8,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        // erase active field
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.backspace),
                        child: Icon(Icons.backspace))),
                Container(
                  width: 8,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        // reload/erase level
                        color: Colors.orangeAccent,
                        onPressed: () => onPressedKey(LogicalKeyboardKey.keyR),
                        child: Icon(Icons.refresh))),
                Container(
                  width: 2,
                ),
              ],
            ),
          ),
          Container(
            height: 4,
          ),
          Container(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 2,
                ),
                Expanded(
                    // initiate help view / hint

                    child: hintSwitch
                        ? VirtualKeyboardButton(
                            color: Colors.black,
                            onPressed: () =>
                                onPressedKey(LogicalKeyboardKey.help),
                            child: Icon(
                              Icons.help_outline,
                              color: Colors.green,
                            ))
                        : VirtualKeyboardButton(
                            onPressed: () =>
                                onPressedKey(LogicalKeyboardKey.help),
                            child: Icon(Icons.help_outline))),
                Container(
                  width: 8,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit5),
                        child: Text("5"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit6),
                        child: Text("6"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit7),
                        child: Text("7"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit8),
                        child: Text("8"))),
                Container(
                  width: 4,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.digit9),
                        child: Text("9"))),
                Container(
                  width: 8,
                ),
                Expanded(
                  child: // on/off option - background graphics
                      optionBackground
                          ? VirtualKeyboardButton(
                              onPressed: () =>
                                  onPressedKey(LogicalKeyboardKey.keyF),
                              color: Colors.black,
                              child: Icon(Icons.image, color: Colors.blue[400]))
                          : VirtualKeyboardButton(
                              onPressed: () =>
                                  onPressedKey(LogicalKeyboardKey.keyG),
                              child: Icon(Icons.image)),
                ),
                Container(
                  width: 8,
                ),
                Expanded(
                    child: VirtualKeyboardButton(
                        // boring / too tough -> skip to next task
                        color: Colors.orangeAccent,
                        onPressed: () =>
                            onPressedKey(LogicalKeyboardKey.mediaTrackNext),
                        child: Icon(Icons.skip_next))),
                Container(
                  width: 2,
                ),
              ],
            ),
          ),
          Container(
            height: 2,
          ),
        ],
      ),
    );
  }
}

//Button class with predefined styling, padding, etc.
class VirtualKeyboardButton extends RaisedButton {
  VirtualKeyboardButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color disabledColor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    Brightness colorBrightness,
    double elevation,
    double focusElevation,
    double hoverElevation,
    double highlightElevation,
    double disabledElevation,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    ShapeBorder shape,
    Clip clipBehavior = Clip.none,
    FocusNode focusNode,
    bool autofocus = false,
    MaterialTapTargetSize materialTapTargetSize,
    Duration animationDuration,
    Widget child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHighlightChanged: onHighlightChanged,
          textTheme: textTheme,
          textColor: textColor,
          disabledTextColor: disabledTextColor,
          color: color,
          disabledColor: disabledColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: splashColor,
          colorBrightness: colorBrightness,
          elevation: elevation,
          focusElevation: focusElevation,
          hoverElevation: hoverElevation,
          highlightElevation: highlightElevation,
          disabledElevation: disabledElevation,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          animationDuration: animationDuration,
          child: child,
        );
}
