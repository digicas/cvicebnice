import 'package:flutter/material.dart';
import 'package:security_keyboard/keyboard_controller.dart';
import 'package:security_keyboard/keyboard_manager.dart';

typedef KeyboardSwitch = Function(SecurityKeyboardType type);

enum SecurityKeyboardType { text }

class SecurityKeyboard extends StatefulWidget {
  ///Controller for keyboard output
  final KeyboardController controller;

  ///Keyboard type - default is text
  final SecurityKeyboardType keyboardType;

  const SecurityKeyboard({this.controller, this.keyboardType});

  ///Text input type
  static SecurityTextInputType text =
      SecurityKeyboard._inputKeyboard(SecurityKeyboardType.text);

  ///Initialization of the keyboard type and returns type of the text input field
  static SecurityTextInputType _inputKeyboard(
      SecurityKeyboardType securityKeyboardType) {
    ///Set keyboard corresponding to the text input field
    String inputType = securityKeyboardType.toString();
    SecurityTextInputType securityTextInputType =
        SecurityTextInputType(name: inputType);

    KeyboardManager.addKeyboard(
      securityTextInputType,
      KeyboardConfig(
        builder: (context, controller) {
          return SecurityKeyboard(
            controller: controller,
            keyboardType: securityKeyboardType,
          );
        },
        getHeight: () {
          return SecurityKeyboard.getHeight(securityKeyboardType);
        },
      ),
    );

    return securityTextInputType;
  }

  ///Keyboard type
  SecurityKeyboardType get _keyboardType => keyboardType;

  ///Method to get the height based on keyboard type
  static double getHeight(SecurityKeyboardType securityKeyboardType) {
    return 48;
  }

  @override
  _SecurityKeyboardState createState() => _SecurityKeyboardState();
}

class _SecurityKeyboardState extends State<SecurityKeyboard> {
  ///Holds and broadcasts actual keyboard type
  SecurityKeyboardType currentKeyboardType;

  @override
  void initState() {
    super.initState();
    currentKeyboardType = widget._keyboardType;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Material(
        child: DefaultTextStyle(
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xffa02b5f),
                fontSize: 18.0),
            child: Center(
              child: Container(
                  height: 50,
                  width: mediaQuery.size.width,
                  color: Color(0xffECE6E9),
                  child: GridView.count(
                    childAspectRatio: (mediaQuery.size.width / 11) / 48,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 2,
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    crossAxisCount: 11,
                    children: <Widget>[
                      buildKeyboardButton('1'),
                      buildKeyboardButton('2'),
                      buildKeyboardButton('3'),
                      buildKeyboardButton('4'),
                      buildKeyboardButton('5'),
                      buildKeyboardButton('6'),
                      buildKeyboardButton('7'),
                      buildKeyboardButton('8'),
                      buildKeyboardButton('9'),
                      buildKeyboardButton('0'),
                      buildKeyboardButton("X",
                          icon: Icon(Icons.backspace),
                          onTapAction: widget.controller.deleteOne),
                    ],
                  )),
            )));
  }

  /// label .. text rendered to button
  /// value .. value entered to editbox controller (if not given action)
  /// icon .. icon rendered to button instead of label
  /// onTapAction .. callback function, such as controller.deleteOne
  ///   default is addText(value)
  Widget buildKeyboardButton(
    String label, {
    String value,
    Icon icon,
    Function onTapAction,
  }) {
    value ??= label;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white70,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: icon == null
              ? Text(label)
              : Icon(icon.icon, size: 18, color: Color(0xff415a70)),
        ),
        onTap: () {
          onTapAction == null
              ? widget.controller.addText(value)
              : onTapAction();
        },
      ),
    );
  }
}
