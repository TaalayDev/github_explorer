import 'package:flutter/material.dart';

class LanguageOption extends StatelessWidget {
  const LanguageOption({super.key, required this.title, required this.isSelected, required this.onTap});

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
    );
  }
}
