import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static void log(String event, Map<String, Object?> params) {
    analytics.logEvent(
      name: event,
      parameters: params,
    );
  }
}
