// Implemented in analytics_service_web.dart and analytics_service_mobile.dart
import 'package:cvicebnice/services/version_service/version_service.dart';

VersionService getVersionService() => throw UnsupportedError(
      '''Cannot create an abstract Upgrade without mobile or web platform target!''',
    );
