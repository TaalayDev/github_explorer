import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/error_message.dart';
import '../../../../shared/presentation/widgets/error_view.dart';
import '../../../../shared/presentation/widgets/loading_indicator.dart';
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
      body: BlocBuilder<UserDetailCubit, UserDetailState>(
        builder: (context, state) {
          return switch (state.status) {
            UserDetailStatus.loading => const LoadingIndicator(),
            UserDetailStatus.failure => ErrorView(
              message: state.errorType!.message(l10n),
              onRetry: context.read<UserDetailCubit>().load,
            ),
            UserDetailStatus.success => UserDetailContent(user: state.user!),
          };
        },
      ),
    );
  }
}
