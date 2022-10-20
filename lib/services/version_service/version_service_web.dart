// platform dependent importer with abstract interface class
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:cvicebnice/services/version_service/version_service.dart';

// Implements the abstract class in version_service and overrides
// the global factory
class VersionServiceWeb implements VersionService {
  VersionServiceWeb();

  @override
  void upgrade() {
    log('Upgrading web app (refresh page)');
    js.context.callMethod('upgradeApp');
  }
}

VersionService getVersionService() => VersionServiceWeb();
