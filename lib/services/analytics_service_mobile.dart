// platform dependent importer with abstract interface class
import 'analytics_service.dart';

// firebase services available: https://github.com/FirebaseExtended/flutterfire

import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';

//class AnalyticsService {
//  final FirebaseAnalytics _analytics = FirebaseAnalytics();
//
//  FirebaseAnalyticsObserver getAnalyticsObserver() =>
//      FirebaseAnalyticsObserver(analytics: _analytics);
//}

// Analytics, implements the abstract class in analytics_service and overrides the global factory
class AnalyticsMobile implements Analytics {
  late FirebaseAnalytics _analytics;

  AnalyticsMobile() {
    _analytics = FirebaseAnalytics();
  }

  void log(String eventName, Map<dynamic, dynamic> eventParams) {
    final Map<String, Object> params = Map<String, Object>.from(eventParams);
    _analytics.logEvent(name: eventName, parameters: params);
    print("log to mobile analytics: $eventName, $eventParams");
  }

  void setUserProperties(Map<String, String> properties) {
    properties.forEach((key, value) {
      _analytics.setUserProperty(name: key, value: value);
      print("set user properties $properties");
    });
  }
}

Analytics getAnalytics() =>
    AnalyticsMobile(); //override global factory to return Web version
