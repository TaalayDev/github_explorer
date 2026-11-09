import 'dart:async';

sealed class UsersEvent {
  const UsersEvent();
}

class UsersRefreshed extends UsersEvent {
  const UsersRefreshed({this.completer});

  final Completer<void>? completer;
}

class UsersNextPageRequested extends UsersEvent {
  const UsersNextPageRequested();
}
