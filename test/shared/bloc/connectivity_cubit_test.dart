import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/shared/bloc/connectivity_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  late _MockConnectivity connectivity;
  late StreamController<List<ConnectivityResult>> controller;

  setUp(() {
    connectivity = _MockConnectivity();
    controller = StreamController<List<ConnectivityResult>>.broadcast();
    when(
      () => connectivity.onConnectivityChanged,
    ).thenAnswer((_) => controller.stream);
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
  });

  tearDown(() => controller.close());

  test('starts online and follows connectivity changes', () async {
    final cubit = ConnectivityCubit(connectivity);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isTrue);

    controller.add([ConnectivityResult.none]);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isFalse);

    controller.add([ConnectivityResult.mobile]);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isTrue);

    await cubit.close();
  });
}
