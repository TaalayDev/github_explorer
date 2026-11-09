import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/users_repository.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(this._repository) : super(const UsersState()) {
    on<UsersRefreshed>(_onRefreshed, transformer: restartable());
    on<UsersNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  final UsersRepository _repository;

  Future<void> _onRefreshed(
    UsersRefreshed event,
    Emitter<UsersState> emit,
  ) async {
    if (state.users.isEmpty) {
      emit(state.copyWith(status: UsersStatus.loading));
    }
    try {
      final users = await _repository.getUsers(since: 0);
      emit(
        UsersState(
          status: UsersStatus.success,
          users: users,
          hasReachedEnd: users.length < UsersRepository.pageSize,
        ),
      );
    } on AppException catch (exception) {
      emit(
        state.copyWith(status: UsersStatus.failure, errorType: exception.type),
      );
    }
  }

  Future<void> _onNextPageRequested(
    UsersNextPageRequested event,
    Emitter<UsersState> emit,
  ) async {
    if (state.isBusy || state.hasReachedEnd || state.users.isEmpty) return;
    emit(state.copyWith(status: UsersStatus.loadingMore));
    try {
      final users = await _repository.getUsers(since: state.users.last.id);
      emit(
        state.copyWith(
          status: UsersStatus.success,
          users: [...state.users, ...users],
          hasReachedEnd: users.length < UsersRepository.pageSize,
        ),
      );
    } on AppException catch (exception) {
      emit(
        state.copyWith(status: UsersStatus.failure, errorType: exception.type),
      );
    }
  }
}
