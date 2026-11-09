import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/config/router/router.dart';
import 'package:github_explorer/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.users,
          builder: (context, state) => const _UsersStub(),
        ),
      ],
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('shows the splash before the delay has passed', (tester) async {
    await pumpApp(tester);
    await tester.pump(splashDuration - const Duration(milliseconds: 1));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(_UsersStub), findsNothing);
  });

  testWidgets('opens the users screen after the delay', (tester) async {
    await pumpApp(tester);
    await tester.pump(splashDuration);
    await tester.pumpAndSettle();

    expect(find.byType(_UsersStub), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('does not navigate when disposed before the delay', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(splashDuration);

    expect(tester.takeException(), isNull);
  });
}

class _UsersStub extends StatelessWidget {
  const _UsersStub();

  @override
  Widget build(BuildContext context) => const SizedBox();
}
