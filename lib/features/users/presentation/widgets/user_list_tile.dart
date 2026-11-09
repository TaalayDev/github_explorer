import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';
import '../../../../shared/presentation/widgets/user_avatar.dart';
import '../../data/models/user.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.user, required this.onTap});

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: UserAvatar(url: user.avatarUrl, radius: 24),
      title: Text(user.login, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('#${user.id}', style: TextStyle(color: context.extraColors.textSecondaryColor)),
      trailing: Icon(Icons.chevron_right, color: context.extraColors.hintColor),
    );
  }
}
