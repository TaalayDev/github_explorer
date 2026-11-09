import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/user_detail.dart';
import '../../data/repositories/users_repository.dart';

enum UserDetailStatus { loading, success, failure }

class UserDetailState extends Equatable {
  const UserDetailState({
    this.status = UserDetailStatus.loading,
    this.user,
    this.errorType,
  });

  final UserDetailStatus status;
  final UserDetail? user;
  final AppErrorType? errorType;

  @override
  List<Object?> get props => [status, user, errorType];
}

class UserDetailCubit extends Cubit<UserDetailState> {
  UserDetailCubit(this._repository, this._login)
    : super(const UserDetailState());

  final UsersRepository _repository;
  final String _login;

  Future<void> load() async {
    emit(const UserDetailState());
    try {
      final user = await _repository.getUser(_login);
      emit(UserDetailState(status: UserDetailStatus.success, user: user));
    } on AppException catch (exception) {
      emit(
        UserDetailState(
          status: UserDetailStatus.failure,
          errorType: exception.type,
        ),
      );
    }
  }
}
