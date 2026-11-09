import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/error_message.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import 'user_list_tile.dart';

const _loadMoreThreshold = 400.0;

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.extentAfter < _loadMoreThreshold) {
      context.read<UsersBloc>().add(const UsersNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UsersBloc>().state;
    final hasFooter =
        state.status == UsersStatus.loadingMore ||
        state.status == UsersStatus.failure;
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<UsersBloc>()..add(const UsersRefreshed());
        await bloc.stream.firstWhere((state) => !state.isBusy);
      },
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.users.length + (hasFooter ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < state.users.length) {
            final user = state.users[index];
            return UserListTile(
              user: user,
              onTap: () => context.push(AppRoutes.userPath(user.login)),
            );
          }
          return const UsersListFooter();
        },
      ),
    );
  }
}

class UsersListFooter extends StatelessWidget {
  const UsersListFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UsersBloc>().state;
    if (state.status == UsersStatus.failure) {
      final l10n = AppLocalizations.of(context);
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(state.errorType!.message(l10n), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  context.read<UsersBloc>().add(const UsersNextPageRequested()),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
