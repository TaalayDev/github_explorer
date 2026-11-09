import 'package:equatable/equatable.dart';

enum AccountType { all, user, org }

enum UserSort { bestMatch, followers, repositories, joined }

enum SortOrder { desc, asc }

class UsersQuery extends Equatable {
  const UsersQuery({
    this.text = '',
    this.accountType = AccountType.all,
    this.sort = UserSort.bestMatch,
    this.order = SortOrder.desc,
  });

  final String text;
  final AccountType accountType;
  final UserSort sort;
  final SortOrder order;

  bool get hasFilters =>
      accountType != AccountType.all || sort != UserSort.bestMatch;

  bool get isSearch => text.trim().isNotEmpty || hasFilters;

  UsersQuery copyWith({
    String? text,
    AccountType? accountType,
    UserSort? sort,
    SortOrder? order,
  }) {
    return UsersQuery(
      text: text ?? this.text,
      accountType: accountType ?? this.accountType,
      sort: sort ?? this.sort,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [text, accountType, sort, order];
}
