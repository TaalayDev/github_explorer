import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/user_avatar.dart';
import '../../data/models/user_detail.dart';

class UserDetailContent extends StatelessWidget {
  const UserDetailContent({super.key, required this.user});

  final UserDetail user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final secondary = context.extraColors.textSecondaryColor;
    final locale = Localizations.localeOf(context).toString();
    final joined = DateFormat.yMMMMd(locale).format(user.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: UserAvatar(url: user.avatarUrl, radius: 56)),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user.displayName,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(user.login, style: textTheme.titleMedium?.copyWith(color: secondary)),
          ),
          const SizedBox(height: 16),
          Text(
            user.bio ?? l10n.noBio,
            style: textTheme.bodyMedium?.copyWith(color: user.bio == null ? secondary : null),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              UserStat(label: l10n.repositories, value: user.publicRepos),
              UserStat(label: l10n.followers, value: user.followers),
              UserStat(label: l10n.following, value: user.following),
            ],
          ),
          const SizedBox(height: 24),
          if (user.company != null)
            UserInfoRow(icon: Icons.business_outlined, label: l10n.company, value: user.company!),
          if (user.location != null)
            UserInfoRow(icon: Icons.place_outlined, label: l10n.location, value: user.location!),
          if (user.blog != null) UserInfoRow(icon: Icons.link, label: l10n.website, value: user.blog!),
          UserInfoRow(icon: Icons.calendar_today_outlined, label: l10n.joined, value: joined),
        ],
      ),
    );
  }
}

class UserStat extends StatelessWidget {
  const UserStat({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            NumberFormat.compact(locale: Localizations.localeOf(context).toString()).format(value),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(label, style: textTheme.bodySmall?.copyWith(color: context.extraColors.textSecondaryColor)),
        ],
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({super.key, required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final secondary = context.extraColors.textSecondaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondary)),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
