enum AppErrorType {
  noConnection,
  rateLimited,
  notFound,
  server,
  unknown;

  static AppErrorType fromName(String? name) {
    return values.asNameMap()[name] ?? AppErrorType.unknown;
  }
}

class AppException implements Exception {
  const AppException(this.type);

  final AppErrorType type;
}
