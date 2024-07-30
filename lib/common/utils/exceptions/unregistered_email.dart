class UnregisteredEmailException implements Exception {
  final String message;

  UnregisteredEmailException(this.message);
}
