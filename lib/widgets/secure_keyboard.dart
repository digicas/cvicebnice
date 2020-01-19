import 'package:flutter/material.dart';
import 'package:security_keyboard/keyboard_controller.dart';
import 'package:security_keyboard/keyboard_manager.dart';

typedef KeyboardSwitch = Function(SecurityKeyboardType type);

enum SecurityKeyboardType { text }

class SecurityKeyboard extends StatefulWidget {
  ///用于控制键盘输出的Controller
  final KeyboardController controller;

  ///键盘类型,默认文本
  final SecurityKeyboardType keyboardType;

  const SecurityKeyboard({this.controller, this.keyboardType});

  ///文本输入类型
  static SecurityTextInputType text =
      SecurityKeyboard._inputKeyboard(SecurityKeyboardType.text);

  ///初始化键盘类型，返回输入框类型
  static SecurityTextInputType _inputKeyboard(
      SecurityKeyboardType securityKeyboardType) {
    ///设置输入框类型对应的键盘
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

  ///键盘类型
  SecurityKeyboardType get _keyboardType => keyboardType;

  ///编写获取高度的方法
  static double getHeight(SecurityKeyboardType securityKeyboardType) {
    return 36;
  }

  @override
  _SecurityKeyboardState createState() => _SecurityKeyboardState();
}

class _SecurityKeyboardState extends State<SecurityKeyboard> {
  ///当前键盘类型
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
                  height: 36,
                  width: mediaQuery.size.width,
                  color: Color(0xffECE6E9),
                  child: GridView.count(
                    childAspectRatio: (mediaQuery.size.width / 12) / 36,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 2,
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    crossAxisCount: 12,
                    children: <Widget>[

                      buildKeyboardButton("D",
                          icon: Icon(Icons.done_outline),
                          onTapAction: widget.controller.doneAction),

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
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white70,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: icon == null
              ? Text(label)
              : Icon(icon.icon, size: 18, color: Color(0xff415a70)
          ),
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
