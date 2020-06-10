// platform dependent importer with abstract interface class
import 'version_service.dart';

// Implements the abstract class in version_service and overrides the global factory
class VersionServiceMobile implements VersionService {
  VersionServiceMobile() {}

  @override
  void upgrade() {
    print("Upgrading mobile app (TODO)");
    // TODO implement mobile app upgrade initiation
  }

}

VersionService getVersionService() => VersionServiceMobile();