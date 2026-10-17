class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => message;
}

class LocationPermissionDeniedException extends LocationServiceException {
  LocationPermissionDeniedException()
      : super('Location permissions are denied. Please grant permission.');
}

class LocationPermissionDeniedForeverException
    extends LocationServiceException {
  LocationPermissionDeniedForeverException()
      : super(
            'Location permissions are permanently denied. Please enable them from settings.');
}

class LocationServicesNotEnabledException extends LocationServiceException {
  LocationServicesNotEnabledException()
      : super('Location services are disabled. Please enable them.');
}

class LocationFetchFailedException extends LocationServiceException {
  LocationFetchFailedException(String error) : super('Failed to get location');
}
