// Main facade and the factory constructor for the analytics
//
// Issue: firebase has different packages for web and mobile, which cannot be compiled together
// Firebase libraries for mobile:
//  firebase_core
//  firebase_auth
//  could_firestore
// Firebase libraries for web: firebase
//
// The future is one, common firebase_core + plugins, but analytics is not covered, yet.
// https://github.com/FirebaseExtended/flutterfire
//
// Conditional imports must be applied see:
// https://blog.gskinner.com/archives/2020/03/flutter-conditional-compilation-for-web.html
// https://stackoverflow.com/questions/58710226/how-to-import-platform-specific-dependency-in-flutter-dart-combine-web-with-an/58713064#58713064
// see http package / client.dart

import "analytics_service_stub.dart"
// ignore: uri_does_not_exist
    if (dart.library.html) "analytics_service_web.dart"
// ignore: uri_does_not_exist
    if (dart.library.io) "analytics_service_mobile.dart";

abstract class Analytics {

  /// logs event to the Firebase - must be implemented for corresponding platform
  void log(String eventName, Map<dynamic, dynamic> eventParams);

  /// factory constructor to return the correct implementation.
  factory Analytics() => getAnalytics();
}

final analytics = Analytics();
