import 'package:equatable/equatable.dart';

import '../../../../core/state/loadable.dart';
import '../../data/models/user.dart';

class UsersState extends Equatable {
  const UsersState({this.users = const Loadable.loading(), this.hasReachedEnd = false});

  final Loadable<List<User>> users;
  final bool hasReachedEnd;

  UsersState copyWith({Loadable<List<User>>? users, bool? hasReachedEnd}) {
    return UsersState(users: users ?? this.users, hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }

  @override
  List<Object?> get props => [users, hasReachedEnd];
}
