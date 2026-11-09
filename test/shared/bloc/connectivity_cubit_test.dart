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

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('starts online and follows connectivity changes', () async {
    final cubit = ConnectivityCubit(connectivity, () async => false);
    await settle();
    expect(cubit.state, isTrue);

    controller.add([ConnectivityResult.none]);
    await settle();
    expect(cubit.state, isFalse);

    controller.add([ConnectivityResult.mobile]);
    await settle();
    expect(cubit.state, isTrue);

    await cubit.close();
  });

  test(
    'stays online when the plugin reports none but the API responds',
    () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      final cubit = ConnectivityCubit(connectivity, () async => true);
      await settle();

      expect(cubit.state, isTrue);
      await cubit.close();
    },
  );

  test('goes offline when the plugin reports none and the API fails', () async {
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    final cubit = ConnectivityCubit(connectivity, () async => false);
    await settle();

    expect(cubit.state, isFalse);
    await cubit.close();
  });
}
