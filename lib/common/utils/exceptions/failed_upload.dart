class FailedUploadException implements Exception {
  final String message;

  FailedUploadException(this.message);
}
