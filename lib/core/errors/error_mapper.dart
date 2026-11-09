import 'package:dio/dio.dart';

import 'app_exception.dart';

AppException mapDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const AppException(
      AppErrorType.noConnection,
    ),
    DioExceptionType.badResponse => _mapStatusCode(
      exception.response?.statusCode,
    ),
    _ => const AppException(AppErrorType.unknown),
  };
}

AppException _mapStatusCode(int? statusCode) {
  return switch (statusCode) {
    403 || 429 => const AppException(AppErrorType.rateLimited),
    404 => const AppException(AppErrorType.notFound),
    final code? when code >= 500 => const AppException(AppErrorType.server),
    _ => const AppException(AppErrorType.unknown),
  };
}
