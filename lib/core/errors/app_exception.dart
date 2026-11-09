enum AppErrorType { noConnection, rateLimited, notFound, server, unknown }

class AppException implements Exception {
  const AppException(this.type);

  final AppErrorType type;
}
