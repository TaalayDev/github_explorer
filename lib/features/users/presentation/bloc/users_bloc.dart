import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/state/loadable.dart';
import '../../data/models/user.dart';
import '../../data/models/users_query.dart';
import '../../data/repositories/users_repository.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(this._repository, {this.searchDebounce = const Duration(milliseconds: 500)}) : super(const UsersState()) {
    on<UsersReloadEvent>(_onReload, transformer: restartable());
    on<UsersNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  final UsersRepository _repository;
  final Duration searchDebounce;

  Future<void> _onReload(UsersReloadEvent event, Emitter<UsersState> emit) async {
    final isRefresh = event is UsersRefreshed;
    try {
      final query = _queryFor(event);
      if (event is UsersSearchChanged) {
        emit(state.copyWith(query: query));
        await Future<void>.delayed(searchDebounce);
        if (emit.isDone) return;
      }
      if (!isRefresh) {
        emit(state.copyWith(query: query, users: const Loadable.loading()));
      } else if (state.users.valueOrNull == null && !state.users.isLoading) {
        emit(state.copyWith(users: const Loadable.loading()));
      }
      final users = await _fetch(query, page: 1, since: 0);
      emit(
        UsersState(
          users: users.isEmpty ? const Loadable.empty() : Loadable.success(users),
          hasReachedEnd: _hasReachedEnd(query, users.length, 1),
          query: query,
        ),
      );
    } on AppException catch (exception) {
      emit(state.copyWith(users: Loadable.error(exception.type.name, isRefresh ? state.users.valueOrNull : null)));
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onNextPageRequested(UsersNextPageRequested event, Emitter<UsersState> emit) async {
    final loaded = state.users.valueOrNull;
    if (state.users.isLoading || state.hasReachedEnd || loaded == null) return;
    final query = state.query;
    final page = state.page + 1;
    emit(state.copyWith(users: state.users.toLoading()));
    try {
      final users = await _fetch(query, page: page, since: loaded.last.id);
      emit(
        state.copyWith(
          users: Loadable.success([...loaded, ...users]),
          hasReachedEnd: _hasReachedEnd(query, users.length, page),
          page: page,
        ),
      );
    } on AppException catch (exception) {
      emit(state.copyWith(users: Loadable.error(exception.type.name, loaded)));
    }
  }

  UsersQuery _queryFor(UsersReloadEvent event) {
    return switch (event) {
      UsersRefreshed() => state.query,
      UsersSearchChanged(:final text) => state.query.copyWith(text: text),
      UsersFilterChanged() => state.query.copyWith(
        accountType: event.accountType,
        sort: event.sort,
        order: event.order,
      ),
    };
  }

  Future<List<User>> _fetch(UsersQuery query, {required int page, required int since}) {
    return query.isSearch ? _repository.searchUsers(query, page: page) : _repository.getUsers(since: since);
  }

  bool _hasReachedEnd(UsersQuery query, int receivedCount, int page) {
    final isLastSearchPage = query.isSearch && page * UsersRepository.pageSize >= UsersRepository.maxSearchResults;
    return receivedCount < UsersRepository.pageSize || isLastSearchPage;
  }
}
