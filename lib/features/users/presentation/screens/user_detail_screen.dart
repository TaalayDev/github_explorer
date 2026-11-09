import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/loadable.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/error_message.dart';
import '../../../../shared/presentation/widgets/error_view.dart';
import '../../../../shared/presentation/widgets/loading_indicator.dart';
import '../../data/models/user_detail.dart';
import '../bloc/user_detail_cubit.dart';
import '../widgets/user_detail_content.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.login});

  final String login;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(login)),
      body: BlocBuilder<UserDetailCubit, Loadable<UserDetail>>(
        builder: (context, state) {
          return state.when(
            success: (user) => UserDetailContent(user: user),
            error: (message, _) =>
                ErrorView(message: localizedError(l10n, message), onRetry: context.read<UserDetailCubit>().load),
            empty: () => const SizedBox.shrink(),
            loading: (_) => const LoadingIndicator(),
          );
        },
      ),
    );
  }
}
