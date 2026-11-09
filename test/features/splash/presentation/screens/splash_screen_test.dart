import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/config/router/router.dart';
import 'package:github_explorer/features/splash/presentation/screens/splash_screen.dart';
import 'package:github_explorer/features/users/presentation/screens/users_screen.dart';
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
          builder: (context, state) => const UsersScreen(),
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
    expect(find.byType(UsersScreen), findsNothing);
  });

  testWidgets('opens the users screen after the delay', (tester) async {
    await pumpApp(tester);
    await tester.pump(splashDuration);
    await tester.pumpAndSettle();

    expect(find.byType(UsersScreen), findsOneWidget);
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
