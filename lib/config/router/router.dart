import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/users/data/repositories/users_repository.dart';
import '../../features/users/presentation/bloc/user_detail_cubit.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../../features/users/presentation/bloc/users_event.dart';
import '../../features/users/presentation/screens/user_detail_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const settings = '/settings';
  static const users = '/users';

  static String userPath(String login) => '/users/$login';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.users,
      builder: (context, state) => BlocProvider(
        create: (context) =>
            UsersBloc(context.read<UsersRepository>())
              ..add(const UsersRefreshed()),
        child: const UsersScreen(),
      ),
      routes: [
        GoRoute(
          path: ':login',
          builder: (context, state) {
            final login = state.pathParameters['login']!;
            return BlocProvider(
              create: (context) =>
                  UserDetailCubit(context.read<UsersRepository>(), login)
                    ..load(),
              child: UserDetailScreen(login: login),
            );
          },
        ),
      ],
    ),
  ],
);
