import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/core/errors/app_exception.dart';
import 'package:github_explorer/core/state/loadable.dart';
import 'package:github_explorer/features/users/data/models/user.dart';
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
}
