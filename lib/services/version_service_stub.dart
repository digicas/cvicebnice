import 'version_service.dart';

// Implemented in analytics_service_web.dart and analytics_service_mobile.dart
VersionService getVersionService() => throw UnsupportedError('Cannot create an abstract Upgrade without mobile or web platform target!');
