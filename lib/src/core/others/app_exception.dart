class AppException implements Exception {
  final String error;
  final StackTrace? stackTrace;

  AppException({
    required this.error,
    this.stackTrace,
  });
}
