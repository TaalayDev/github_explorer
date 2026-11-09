import 'dart:async';

import '../../data/models/users_query.dart';

sealed class UsersEvent {
  const UsersEvent();
}

sealed class UsersReloadEvent extends UsersEvent {
  const UsersReloadEvent({this.completer});

  final Completer<void>? completer;
}

class UsersRefreshed extends UsersReloadEvent {
  const UsersRefreshed({super.completer});
}

class UsersSearchChanged extends UsersReloadEvent {
  const UsersSearchChanged(this.text);

  final String text;
}

class UsersFilterChanged extends UsersReloadEvent {
  const UsersFilterChanged({required this.accountType, required this.sort, required this.order});

  final AccountType accountType;
  final UserSort sort;
  final SortOrder order;
}

class UsersNextPageRequested extends UsersEvent {
  const UsersNextPageRequested();
}
