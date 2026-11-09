import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/state/loadable.dart';
import '../../data/models/user.dart';
import '../../data/repositories/users_repository.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(this._repository) : super(const UsersState()) {
    on<UsersRefreshed>(_onRefreshed, transformer: restartable());
    on<UsersNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  final UsersRepository _repository;

  Future<void> _onRefreshed(UsersRefreshed event, Emitter<UsersState> emit) async {
    if (state.users.valueOrNull == null && !state.users.isLoading) {
      emit(state.copyWith(users: const Loadable.loading()));
    }
    try {
      final users = await _repository.getUsers(since: 0);
      emit(UsersState(users: _toLoadable(users), hasReachedEnd: users.length < UsersRepository.pageSize));
    } on AppException catch (exception) {
      emit(state.copyWith(users: Loadable.error(exception.type.name, state.users.valueOrNull)));
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onNextPageRequested(UsersNextPageRequested event, Emitter<UsersState> emit) async {
    final loaded = state.users.valueOrNull;
    if (state.users.isLoading || state.hasReachedEnd || loaded == null) return;
    emit(state.copyWith(users: state.users.toLoading()));
    try {
      final users = await _repository.getUsers(since: loaded.last.id);
      emit(
        state.copyWith(
          users: Loadable.success([...loaded, ...users]),
          hasReachedEnd: users.length < UsersRepository.pageSize,
        ),
      );
    } on AppException catch (exception) {
      emit(state.copyWith(users: Loadable.error(exception.type.name, loaded)));
    }
  }

  Loadable<List<User>> _toLoadable(List<User> users) {
    return users.isEmpty ? const Loadable.empty() : Loadable.success(users);
  }
}
