import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const users = '/users';
}

final appRouter = GoRouter(
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
