// platform dependent importer with abstract interface class
import 'dart:developer';

import 'package:cvicebnice/services/version_service/version_service.dart';

// Implements the abstract class in version_service and overrides
// the global factory
class VersionServiceMobile implements VersionService {
  VersionServiceMobile();

  @override
  void upgrade() {
    log('Upgrading mobile app (TODO)');
    // TODO(KeepItSaber): implement mobile app upgrade initiation
  }
}

VersionService getVersionService() => VersionServiceMobile();
