import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/features/users/data/models/users_query.dart';
import 'package:github_explorer/features/users/data/repositories/users_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late UsersRepository repository;
  Map<String, dynamic>? captured;

  setUp(() {
    dio = _MockDio();
    repository = UsersRepository(dio);
    captured = null;
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((invocation) async {
      captured =
          invocation.namedArguments[#queryParameters] as Map<String, dynamic>;
      return Response(
        requestOptions: RequestOptions(path: '/search/users'),
        data: {
          'items': [
            {'id': 1, 'login': 'a', 'avatar_url': 'https://example.com/a.png'},
          ],
        },
      );
    });
  });

  test('builds the search query with text and account type', () async {
    final users = await repository.searchUsers(
      const UsersQuery(text: ' linus ', accountType: AccountType.org),
      page: 2,
    );

    expect(users.single.login, 'a');
    expect(captured, {'q': 'linus type:org', 'page': 2, 'per_page': 30});
  });

  test('adds sort and order only when sorting', () async {
    await repository.searchUsers(
      const UsersQuery(
        text: 'linus',
        sort: UserSort.repositories,
        order: SortOrder.asc,
      ),
      page: 1,
    );

    expect(captured, {
      'q': 'linus',
      'sort': 'repositories',
      'order': 'asc',
      'page': 1,
      'per_page': 30,
    });
  });

  test('matches everyone when only sorting without text', () async {
    await repository.searchUsers(
      const UsersQuery(sort: UserSort.joined),
      page: 1,
    );

    expect(captured?['q'], 'followers:>=0');
  });
}
