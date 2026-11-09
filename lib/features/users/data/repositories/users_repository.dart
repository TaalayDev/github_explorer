import 'package:dio/dio.dart';

import '../../../../core/errors/error_mapper.dart';
import '../models/user.dart';
import '../models/user_detail.dart';
import '../models/users_query.dart';

class UsersRepository {
  const UsersRepository(this._dio);

  static const pageSize = 30;
  static const maxSearchResults = 1000;
  static const _matchAllQuery = 'followers:>=0';

  final Dio _dio;

  Future<List<User>> getUsers({required int since}) async {
    try {
      final response = await _dio.get<List<dynamic>>('/users', queryParameters: {'since': since, 'per_page': pageSize});
      return response.data!.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  Future<List<User>> searchUsers(UsersQuery query, {required int page}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search/users',
        queryParameters: {
          'q': _buildSearchQuery(query),
          if (query.sort != UserSort.bestMatch) ...{'sort': query.sort.name, 'order': query.order.name},
          'page': page,
          'per_page': pageSize,
        },
      );
      return (response.data!['items'] as List<dynamic>)
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

  String _buildSearchQuery(UsersQuery query) {
    final parts = [
      query.text.trim(),
      if (query.accountType != AccountType.all) 'type:${query.accountType.name}',
    ].where((part) => part.isNotEmpty);
    return parts.isEmpty ? _matchAllQuery : parts.join(' ');
  }
}
