import 'package:equatable/equatable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/user.dart';

enum UsersStatus { initial, loading, loadingMore, success, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.hasReachedEnd = false,
    this.errorType,
  });

  final UsersStatus status;
  final List<User> users;
  final bool hasReachedEnd;
  final AppErrorType? errorType;

  bool get isBusy => status == UsersStatus.loading || status == UsersStatus.loadingMore;

  UsersState copyWith({UsersStatus? status, List<User>? users, bool? hasReachedEnd, AppErrorType? errorType}) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorType: errorType,
    );
  }

  @override
  List<Object?> get props => [status, users, hasReachedEnd, errorType];
}
