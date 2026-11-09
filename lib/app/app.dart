import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/router/router.dart';
import '../config/theme/theme.dart';
import '../features/users/data/repositories/users_repository.dart';
import '../l10n/app_localizations.dart';
import '../shared/bloc/connectivity_cubit.dart';
import '../shared/data/network/api_client.dart';
import '../shared/presentation/widgets/connectivity_banner.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => createApiClient(),
      child: RepositoryProvider(
        create: (context) => UsersRepository(context.read<Dio>()),
        child: BlocProvider(
          create: (context) => ConnectivityCubit(
            Connectivity(),
            () => isApiReachable(context.read<Dio>()),
          ),
          child: MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.defaultTheme.themeData,
            routerConfig: appRouter,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Column(
              children: [
                Expanded(child: child!),
                const ConnectivityBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
