import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/bloc/connectivity_cubit.dart';
import '../../../../shared/presentation/error_message.dart';
import '../../../../shared/presentation/widgets/error_view.dart';
import '../../../../shared/presentation/widgets/loading_indicator.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import '../widgets/users_list.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<ConnectivityCubit, bool>(
      listenWhen: (previous, current) => !previous && current,
      listener: (context, isOnline) {
        final state = context.read<UsersBloc>().state;
        if (state.status == UsersStatus.failure) {
          context.read<UsersBloc>().add(const UsersRefreshed());
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.usersTitle)),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state.users.isEmpty) {
              return switch (state.status) {
                UsersStatus.failure => ErrorView(
                  message: state.errorType!.message(l10n),
                  onRetry: () =>
                      context.read<UsersBloc>().add(const UsersRefreshed()),
                ),
                UsersStatus.success => Center(child: Text(l10n.emptyUsers)),
                _ => const LoadingIndicator(),
              };
            }
            return const UsersList();
          },
        ),
      ),
    );
  }
}
