//import 'package:cool_ui/cool_ui.dart';
//import 'package:flutter/material.dart';
//
//class SmallNumericKeyboard extends StatelessWidget {
//  static const CKTextInputType inputType =
//      const CKTextInputType(name: 'CKNumberKeyboard');
//
//  static double getHeight(BuildContext ctx) {
//    MediaQueryData mediaQuery = MediaQuery.of(ctx);
//    return mediaQuery.size.width / 6 ;
////    return 128.0;
//  }
//
//  final KeyboardController controller;
//
//  const SmallNumericKeyboard({this.controller});
//
//  static register() {
//    CoolKeyboard.addKeyboard(
//        SmallNumericKeyboard.inputType,
//        KeyboardConfig(
//            builder: (context, controller, params) {
//              return SmallNumericKeyboard(controller: controller);
//            },
//            getHeight: SmallNumericKeyboard.getHeight));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    MediaQueryData mediaQuery = MediaQuery.of(context);
//    return Material(
//        child: DefaultTextStyle(
//            style: TextStyle(
//                fontWeight: FontWeight.w500,
//                color: Color(0xffa02b5f),
//                fontSize: 20.0),
//            child: Container(
////              height: 128,
//              width: mediaQuery.size.width,
//              color: Color(0xffECE6E9),
////              color: Color(0xff334455),
//              child: GridView.count(
//                childAspectRatio: 2 / 1,
//                mainAxisSpacing: 0.5,
//                crossAxisSpacing: 0.5,
//                padding: EdgeInsets.all(0.0),
//                crossAxisCount: 6,
//                children: <Widget>[
//                  buildButton('1'),
//                  buildButton('2'),
//                  buildButton('3'),
//                  buildButton('4'),
//                  buildButton('5'),
//                  buildButton('X'),
//                  buildButton('6'),
//                  buildButton('7'),
//                  buildButton('8'),
//                  buildButton('9'),
//                  buildButton('0'),
//                  buildButton('E'),
//
//                ],
//
//              )
//
//            )));
//  }
//
////  @override
////  Widget build(BuildContext context) {
////    MediaQueryData mediaQuery = MediaQuery.of(context);
////    return Material(
////      child: DefaultTextStyle(
////          style: TextStyle(
////              fontWeight: FontWeight.w500, color: Colors.pinkAccent, fontSize: 23.0),
////          child: Container(
////            height: getHeight(context),
//////            width: mediaQuery.size.width,
////            decoration: BoxDecoration(
////              color: Color(0xffafafaf),
////            ),
////            child: GridView.count(
////                childAspectRatio: 2 / 1,
////                mainAxisSpacing: 0.5,
////                crossAxisSpacing: 0.5,
////                padding: EdgeInsets.all(0.0),
////                crossAxisCount: 3,
////                children: <Widget>[
////                  buildButton('1'),
////                  buildButton('2'),
////                  buildButton('3'),
////                  buildButton('4'),
////                  buildButton('5'),
////                  buildButton('6'),
////                  buildButton('7'),
////                  buildButton('8'),
////                  buildButton('9'),
////                  Container(
////                    color: Color(0xFFd3d6dd),
////                    child: GestureDetector(
////                      behavior: HitTestBehavior.translucent,
////                      child: Center(
////                        child: Icon(Icons.expand_more),
////                      ),
////                      onTap: () {
////                        controller.doneAction();
////                      },
////                    ),
////                  ),
////                  buildButton('0'),
////                  Container(
////                    color: Color(0xFFd3d6dd),
////                    child: GestureDetector(
////                      behavior: HitTestBehavior.translucent,
////                      child: Center(
////                        child: Text('X'),
////                      ),
////                      onTap: () {
////                        controller.deleteOne();
////                      },
////                    ),
////                  ),
////                ]),
////          )),
////    );
////  }
//
//  Widget buildButton(String title, {String value}) {
//    if (value == null) {
//      value = title;
//    }
//    return Container(
//      color: Colors.white,
//      child: GestureDetector(
//        behavior: HitTestBehavior.translucent,
//        child: Center(
//          child: Text(title),
//        ),
//        onTap: () {
//          controller.addText(value);
//        },
//      ),
//    );
//  }
//}
//
////onTap: () {
////controller.addText(value);
////},
