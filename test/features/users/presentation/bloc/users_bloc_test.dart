import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/core/errors/app_exception.dart';
import 'package:github_explorer/core/state/loadable.dart';
import 'package:github_explorer/features/users/data/models/user.dart';
import 'package:github_explorer/features/users/data/models/users_query.dart';
import 'package:github_explorer/features/users/data/repositories/users_repository.dart';
import 'package:github_explorer/features/users/presentation/bloc/users_bloc.dart';
import 'package:github_explorer/features/users/presentation/bloc/users_event.dart';
import 'package:github_explorer/features/users/presentation/bloc/users_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersRepository extends Mock implements UsersRepository {}

List<User> _users(int from, int count) => List.generate(
  count,
  (index) => User(
    id: from + index,
    login: 'user${from + index}',
    avatarUrl: 'https://example.com/${from + index}.png',
  ),
);

void main() {
  late _MockUsersRepository repository;
  final firstPage = _users(1, UsersRepository.pageSize);
  final secondPage = _users(UsersRepository.pageSize + 1, 5);

  setUpAll(() => registerFallbackValue(const UsersQuery()));

  setUp(() => repository = _MockUsersRepository());

  blocTest<UsersBloc, UsersState>(
    'loads the first page',
    build: () {
      when(
        () => repository.getUsers(since: 0),
      ).thenAnswer((_) async => firstPage);
      return UsersBloc(repository);
    },
    act: (bloc) => bloc.add(const UsersRefreshed()),
    expect: () => [UsersState(users: Loadable.success(firstPage))],
  );

  blocTest<UsersBloc, UsersState>(
    'reports an empty result',
    build: () {
      when(() => repository.getUsers(since: 0)).thenAnswer((_) async => []);
      return UsersBloc(repository);
    },
    act: (bloc) => bloc.add(const UsersRefreshed()),
    expect: () => const [
      UsersState(users: Loadable.empty(), hasReachedEnd: true),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'appends the next page using the last user id and marks the end',
    build: () {
      when(
        () => repository.getUsers(since: firstPage.last.id),
      ).thenAnswer((_) async => secondPage);
      return UsersBloc(repository);
    },
    seed: () => UsersState(users: Loadable.success(firstPage)),
    act: (bloc) => bloc.add(const UsersNextPageRequested()),
    expect: () => [
      UsersState(users: Loadable.loading(firstPage)),
      UsersState(
        users: Loadable.success([...firstPage, ...secondPage]),
        hasReachedEnd: true,
        page: 2,
      ),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'does not request more once the end is reached',
    build: () => UsersBloc(repository),
    seed: () =>
        UsersState(users: Loadable.success(secondPage), hasReachedEnd: true),
    act: (bloc) => bloc.add(const UsersNextPageRequested()),
    expect: () => <UsersState>[],
    verify: (_) =>
        verifyNever(() => repository.getUsers(since: any(named: 'since'))),
  );

  blocTest<UsersBloc, UsersState>(
    'reports a failure on the first page',
    build: () {
      when(
        () => repository.getUsers(since: 0),
      ).thenThrow(const AppException(AppErrorType.noConnection));
      return UsersBloc(repository);
    },
    act: (bloc) => bloc.add(const UsersRefreshed()),
    expect: () => [
      UsersState(users: Loadable.error(AppErrorType.noConnection.name)),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'keeps loaded users when the next page fails',
    build: () {
      when(
        () => repository.getUsers(since: firstPage.last.id),
      ).thenThrow(const AppException(AppErrorType.server));
      return UsersBloc(repository);
    },
    seed: () => UsersState(users: Loadable.success(firstPage)),
    act: (bloc) => bloc.add(const UsersNextPageRequested()),
    expect: () => [
      UsersState(users: Loadable.loading(firstPage)),
      UsersState(users: Loadable.error(AppErrorType.server.name, firstPage)),
    ],
  );

  test('completes the refresh completer', () async {
    when(
      () => repository.getUsers(since: 0),
    ).thenAnswer((_) async => firstPage);
    final bloc = UsersBloc(repository);
    final completer = Completer<void>();

    bloc.add(UsersRefreshed(completer: completer));

    await completer.future.timeout(const Duration(seconds: 1));
    await bloc.close();
  });

  group('search and filters', () {
    const searchQuery = UsersQuery(text: 'linus');
    const sortedQuery = UsersQuery(
      text: 'linus',
      accountType: AccountType.user,
      sort: UserSort.followers,
    );

    blocTest<UsersBloc, UsersState>(
      'searches by text after the debounce',
      build: () {
        when(
          () => repository.searchUsers(searchQuery, page: 1),
        ).thenAnswer((_) async => secondPage);
        return UsersBloc(repository, searchDebounce: Duration.zero);
      },
      act: (bloc) => bloc.add(const UsersSearchChanged('linus')),
      expect: () => [
        const UsersState(query: searchQuery),
        UsersState(
          users: Loadable.success(secondPage),
          hasReachedEnd: true,
          query: searchQuery,
        ),
      ],
      verify: (_) {
        verify(() => repository.searchUsers(searchQuery, page: 1)).called(1);
        verifyNever(() => repository.getUsers(since: any(named: 'since')));
      },
    );

    blocTest<UsersBloc, UsersState>(
      'only the latest search is requested while typing',
      build: () {
        when(
          () => repository.searchUsers(any(), page: any(named: 'page')),
        ).thenAnswer((_) async => secondPage);
        return UsersBloc(
          repository,
          searchDebounce: const Duration(milliseconds: 50),
        );
      },
      act: (bloc) {
        bloc
          ..add(const UsersSearchChanged('l'))
          ..add(const UsersSearchChanged('li'))
          ..add(const UsersSearchChanged('lin'));
      },
      wait: const Duration(milliseconds: 200),
      verify: (_) {
        verify(
          () => repository.searchUsers(const UsersQuery(text: 'lin'), page: 1),
        ).called(1);
        verifyNever(
          () => repository.searchUsers(
            const UsersQuery(text: 'l'),
            page: any(named: 'page'),
          ),
        );
      },
    );

    blocTest<UsersBloc, UsersState>(
      'applies filters and sort on top of the current text',
      build: () {
        when(
          () => repository.searchUsers(sortedQuery, page: 1),
        ).thenAnswer((_) async => secondPage);
        return UsersBloc(repository, searchDebounce: Duration.zero);
      },
      seed: () => const UsersState(query: searchQuery),
      act: (bloc) => bloc.add(
        const UsersFilterChanged(
          accountType: AccountType.user,
          sort: UserSort.followers,
          order: SortOrder.desc,
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.query, sortedQuery);
        expect(bloc.state.users.valueOrNull, secondPage);
      },
    );

    blocTest<UsersBloc, UsersState>(
      'returns to the plain list when search and filters are cleared',
      build: () {
        when(
          () => repository.getUsers(since: 0),
        ).thenAnswer((_) async => firstPage);
        return UsersBloc(repository, searchDebounce: Duration.zero);
      },
      seed: () => const UsersState(query: searchQuery),
      act: (bloc) => bloc.add(const UsersSearchChanged('')),
      verify: (bloc) {
        expect(bloc.state.query, const UsersQuery());
        expect(bloc.state.users.valueOrNull, firstPage);
        verify(() => repository.getUsers(since: 0)).called(1);
      },
    );

    blocTest<UsersBloc, UsersState>(
      'requests the next search page by page number',
      build: () {
        when(
          () => repository.searchUsers(searchQuery, page: 2),
        ).thenAnswer((_) async => secondPage);
        return UsersBloc(repository);
      },
      seed: () =>
          UsersState(users: Loadable.success(firstPage), query: searchQuery),
      act: (bloc) => bloc.add(const UsersNextPageRequested()),
      verify: (bloc) {
        verify(() => repository.searchUsers(searchQuery, page: 2)).called(1);
        expect(bloc.state.page, 2);
      },
    );

    blocTest<UsersBloc, UsersState>(
      'stops at the GitHub search result limit',
      build: () {
        when(
          () => repository.searchUsers(searchQuery, page: 34),
        ).thenAnswer((_) async => firstPage);
        return UsersBloc(repository);
      },
      seed: () => UsersState(
        users: Loadable.success(firstPage),
        query: searchQuery,
        page: 33,
      ),
      act: (bloc) => bloc.add(const UsersNextPageRequested()),
      verify: (bloc) => expect(bloc.state.hasReachedEnd, isTrue),
    );

    blocTest<UsersBloc, UsersState>(
      'shows an empty result for a search without matches',
      build: () {
        when(
          () => repository.searchUsers(searchQuery, page: 1),
        ).thenAnswer((_) async => []);
        return UsersBloc(repository, searchDebounce: Duration.zero);
      },
      act: (bloc) => bloc.add(const UsersSearchChanged('linus')),
      verify: (bloc) => expect(bloc.state.users.isEmpty, isTrue),
    );
  });
}
