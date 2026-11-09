import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/bloc/connectivity_cubit.dart';
import '../../../../shared/presentation/error_message.dart';
import '../../../../shared/presentation/widgets/error_view.dart';
import '../../../../shared/presentation/widgets/loading_indicator.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import '../widgets/users_list.dart';
import '../widgets/users_search_bar.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<ConnectivityCubit, bool>(
      listenWhen: (previous, current) => !previous && current,
      listener: (context, isOnline) {
        final bloc = context.read<UsersBloc>();
        if (bloc.state.users.isError) bloc.add(const UsersRefreshed());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.usersTitle),
          actions: [
            IconButton(
              tooltip: l10n.settingsTitle,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(AppRoutes.settings),
            ),
          ],
          bottom: const UsersSearchBar(),
        ),
        body: BlocBuilder<UsersBloc, UsersState>(
          buildWhen: (previous, current) => previous.users != current.users,
          builder: (context, state) {
            return state.users.when(
              success: (_) => const UsersList(),
              empty: () => Center(child: Text(l10n.emptyUsers)),
              error: (message, previous) => previous == null
                  ? ErrorView(
                      message: localizedError(l10n, message),
                      onRetry: () => context.read<UsersBloc>().add(const UsersRefreshed()),
                    )
                  : const UsersList(),
              loading: (previous) => previous == null ? const LoadingIndicator() : const UsersList(),
            );
          },
        ),
      ),
    );
  }
}
