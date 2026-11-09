import 'package:dio/dio.dart';

import '../../../../core/errors/error_mapper.dart';
import '../models/user.dart';
import '../models/user_detail.dart';

class UsersRepository {
  const UsersRepository(this._dio);

  static const pageSize = 30;

  final Dio _dio;

  Future<List<User>> getUsers({required int since}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/users',
        queryParameters: {'since': since, 'per_page': pageSize},
      );
      return response.data!
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  Future<UserDetail> getUser(String login) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/$login');
      return UserDetail.fromJson(response.data!);
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}
