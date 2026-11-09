sealed class UsersEvent {
  const UsersEvent();
}

class UsersRefreshed extends UsersEvent {
  const UsersRefreshed();
}

class UsersNextPageRequested extends UsersEvent {
  const UsersNextPageRequested();
}
