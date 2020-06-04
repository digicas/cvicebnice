import 'analytics_service.dart';

// Implemented in analytics_service_web.dart and analytics_service_mobile.dart
Analytics getAnalytics() => throw UnsupportedError('Cannot create an abstract Analytics without mobile or web platform target!');
