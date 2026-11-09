import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import 'users_filter_sheet.dart';

class UsersSearchBar extends StatefulWidget implements PreferredSizeWidget {
  const UsersSearchBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  State<UsersSearchBar> createState() => _UsersSearchBarState();
}

class _UsersSearchBarState extends State<UsersSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: context.read<UsersBloc>().state.query.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    context.read<UsersBloc>().add(UsersSearchChanged(text));
  }

  void _onClear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasFilters = context.select((UsersBloc bloc) => bloc.state.query.hasFilters);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, _) => TextField(
                controller: _controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: value.text.isEmpty
                      ? null
                      : IconButton(icon: const Icon(Icons.close), onPressed: _onClear),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: l10n.filtersTitle,
            onPressed: () => UsersFilterSheet.show(context),
            icon: Badge(isLabelVisible: hasFilters, smallSize: 8, child: const Icon(Icons.tune)),
          ),
        ],
      ),
    );
  }
}
