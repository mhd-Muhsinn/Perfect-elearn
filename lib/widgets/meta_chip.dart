import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/widgets/tag_chip.dart';

class MetaChips extends StatelessWidget {
  final List<(String, String)> items;
  const MetaChips({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
     direction: Axis.horizontal,
      spacing: 2,
      runSpacing: 8,
      children: items
          .where((e) => e.$2.trim().isNotEmpty)
          .map((e) => TagChip(
                leadingIcon: Icons.category_outlined,
                label: e.$2,
                background: PColors.primary,
                foreground: PColors.backgrndPrimary,
              ))
          .toList(),
    );
  }
}