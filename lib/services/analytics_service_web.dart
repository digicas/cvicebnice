// firebase analytics
// https://www.filledstacks.com/post/firebase-analytics-and-metrics-in-flutter/
// https://medium.com/flutter-community/the-flutter-guide-to-firebase-analytics-9b99c6e27a6

// platform dependent importer with abstract interface class
import 'analytics_service.dart';

// Firebase package for web
import 'package:firebase/firebase.dart' as WebFirebase;

//final WebFirebase.Analytics analytics = WebFirebase.analytics();
//final FirebaseAnalytics analytics = FirebaseAnalytics();

// Analytics, implements the abstract class in analytics_service and overrides the global factory
class AnalyticsWeb implements Analytics {
  late WebFirebase.Analytics _analytics;

  AnalyticsWeb() {
    _analytics = WebFirebase.analytics();
  }

  void log(String eventName, Map<dynamic, dynamic> eventParams) {
    _analytics.logEvent(eventName, eventParams);
    print("log to web analytics: $eventName, $eventParams");
  }

  void setUserProperties(Map<String, String> properties) {
    _analytics.setUserProperties(properties);
    print("set user properties $properties");
  }
}

Analytics getAnalytics() =>
    AnalyticsWeb(); //override global factory to return Web version
