import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit(this._connectivity, this._isReachable) : super(true) {
    _subscription = _connectivity.onConnectivityChanged.listen(_update);
    _connectivity.checkConnectivity().then(_update);
  }

  final Connectivity _connectivity;
  final Future<bool> Function() _isReachable;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  int _updateId = 0;

  Future<void> _update(List<ConnectivityResult> results) async {
    final updateId = ++_updateId;
    final hasInterface = results.any(
      (result) => result != ConnectivityResult.none,
    );
    final isOnline = hasInterface || await _isReachable();
    if (!isClosed && updateId == _updateId) emit(isOnline);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
