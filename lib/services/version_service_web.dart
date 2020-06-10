// platform dependent importer with abstract interface class
import 'version_service.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

// Implements the abstract class in version_service and overrides the global factory
class VersionServiceWeb implements VersionService {
  VersionServiceWeb() {}

  @override
  void upgrade() {
    print("Upgrading web app (refresh page)");
    js.context.callMethod('upgradeApp');
  }

}

VersionService getVersionService() => VersionServiceWeb();