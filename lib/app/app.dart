import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/router/router.dart';
import '../config/theme/theme.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../features/users/data/repositories/users_repository.dart';
import '../l10n/app_localizations.dart';
import '../shared/bloc/connectivity_cubit.dart';
import '../shared/data/network/api_client.dart';
import '../shared/presentation/widgets/connectivity_banner.dart';

class App extends StatelessWidget {
  const App({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => createApiClient()),
        RepositoryProvider(
          create: (context) => UsersRepository(context.read<Dio>()),
        ),
        RepositoryProvider(
          create: (context) => SettingsRepository(preferences),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ConnectivityCubit(
              Connectivity(),
              () => isApiReachable(context.read<Dio>()),
            ),
          ),
          BlocProvider(
            create: (context) =>
                SettingsCubit(context.read<SettingsRepository>()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.select((SettingsCubit cubit) => cubit.state.locale);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme.themeData,
      routerConfig: appRouter,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => Column(
        children: [
          Expanded(child: child!),
          const ConnectivityBanner(),
        ],
      ),
    );
  }
}
