// Main facade and the factory constructor for the version upgrade service
//
// Issue: web force upgrade and mobil upgrade cannot be compiled together
// Solution: conditional imports

import "version_service_stub.dart"
    // ignore: uri_does_not_exist
  if (dart.library.html) "version_service_web.dart"
  // ignore: uri_does_not_exist
  if (dart.library.io) "version_service_mobile.dart";

abstract class VersionService {

  /// Initiates the upgrade
  /// JS refresh in web case, tbd for mobile
  /// - must be implemented for corresponding platform
  void upgrade();

  /// factory constructor to return the correct implementation.
  factory VersionService() => getVersionService();
}

final versionService = VersionService();
