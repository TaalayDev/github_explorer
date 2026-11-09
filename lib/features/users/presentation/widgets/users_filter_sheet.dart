import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../../data/models/users_query.dart';
import '../query_labels.dart';

class UsersFilterSheet extends StatelessWidget {
  const UsersFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(value: bloc, child: const UsersFilterSheet()),
    );
  }

  void _apply(BuildContext context, {AccountType? accountType, UserSort? sort, SortOrder? order}) {
    final query = context.read<UsersBloc>().state.query;
    context.read<UsersBloc>().add(
      UsersFilterChanged(
        accountType: accountType ?? query.accountType,
        sort: sort ?? query.sort,
        order: order ?? query.order,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = context.select((UsersBloc bloc) => bloc.state.query);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l10n.filtersTitle, style: Theme.of(context).textTheme.titleLarge)),
                if (query.hasFilters)
                  TextButton(
                    onPressed: () =>
                        _apply(context, accountType: AccountType.all, sort: UserSort.bestMatch, order: SortOrder.desc),
                    child: Text(l10n.resetFilters),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilterSection<AccountType>(
              title: l10n.accountTypeTitle,
              values: AccountType.values,
              selected: query.accountType,
              labelOf: (value) => value.label(l10n),
              onSelected: (value) => _apply(context, accountType: value),
            ),
            const SizedBox(height: 16),
            FilterSection<UserSort>(
              title: l10n.sortByTitle,
              values: UserSort.values,
              selected: query.sort,
              labelOf: (value) => value.label(l10n),
              onSelected: (value) => _apply(context, sort: value),
            ),
            const SizedBox(height: 16),
            Text(l10n.orderTitle, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<SortOrder>(
              segments: [
                for (final order in SortOrder.values) ButtonSegment(value: order, label: Text(order.label(l10n))),
              ],
              selected: {query.order},
              onSelectionChanged: query.sort == UserSort.bestMatch
                  ? null
                  : (selection) => _apply(context, order: selection.first),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterSection<T> extends StatelessWidget {
  const FilterSection({
    super.key,
    required this.title,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final String title;
  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              ChoiceChip(
                label: Text(labelOf(value)),
                selected: value == selected,
                onSelected: (_) => onSelected(value),
              ),
          ],
        ),
      ],
    );
  }
}
