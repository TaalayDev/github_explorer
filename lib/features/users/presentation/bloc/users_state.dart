import 'package:equatable/equatable.dart';

import '../../../../core/state/loadable.dart';
import '../../data/models/user.dart';
import '../../data/models/users_query.dart';

class UsersState extends Equatable {
  const UsersState({
    this.users = const Loadable.loading(),
    this.hasReachedEnd = false,
    this.query = const UsersQuery(),
    this.page = 1,
  });

  final Loadable<List<User>> users;
  final bool hasReachedEnd;
  final UsersQuery query;
  final int page;

  UsersState copyWith({Loadable<List<User>>? users, bool? hasReachedEnd, UsersQuery? query, int? page}) {
    return UsersState(
      users: users ?? this.users,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedEnd, query, page];
}
