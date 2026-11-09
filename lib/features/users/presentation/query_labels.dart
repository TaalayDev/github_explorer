import '../../../l10n/app_localizations.dart';
import '../data/models/users_query.dart';

extension AccountTypeLabel on AccountType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      AccountType.all => l10n.accountTypeAll,
      AccountType.user => l10n.accountTypeUser,
      AccountType.org => l10n.accountTypeOrg,
    };
  }
}

extension UserSortLabel on UserSort {
  String label(AppLocalizations l10n) {
    return switch (this) {
      UserSort.bestMatch => l10n.sortBestMatch,
      UserSort.followers => l10n.sortFollowers,
      UserSort.repositories => l10n.sortRepositories,
      UserSort.joined => l10n.sortJoined,
    };
  }
}

extension SortOrderLabel on SortOrder {
  String label(AppLocalizations l10n) {
    return switch (this) {
      SortOrder.desc => l10n.orderDescending,
      SortOrder.asc => l10n.orderAscending,
    };
  }
}
