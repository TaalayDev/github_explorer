import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/core/errors/app_exception.dart';
import 'package:github_explorer/core/errors/error_mapper.dart';

DioException _badResponse(int statusCode) {
  final options = RequestOptions(path: '/');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: statusCode),
  );
}

void main() {
  test('maps connection failures to noConnection', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.connectionError,
    );

    expect(mapDioException(exception).type, AppErrorType.noConnection);
  });

  test('maps timeouts to noConnection', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.receiveTimeout,
    );

    expect(mapDioException(exception).type, AppErrorType.noConnection);
  });

  test('maps 403 and 429 to rateLimited', () {
    expect(mapDioException(_badResponse(403)).type, AppErrorType.rateLimited);
    expect(mapDioException(_badResponse(429)).type, AppErrorType.rateLimited);
  });

  test('maps 404 to notFound', () {
    expect(mapDioException(_badResponse(404)).type, AppErrorType.notFound);
  });

  test('maps 5xx to server', () {
    expect(mapDioException(_badResponse(503)).type, AppErrorType.server);
  });

  test('maps other failures to unknown', () {
    expect(mapDioException(_badResponse(400)).type, AppErrorType.unknown);
  });
}
