import 'package:flutter/material.dart';

/// A reusable, rounded chip for tags/metadata
class TagChip extends StatelessWidget {
  final IconData? leadingIcon;
  final String label;
  final Color? background;
  final Color? foreground;
  final String? tooltip;

  const TagChip({super.key, 
    required this.label,
    this.leadingIcon,
    this.background,
    this.foreground,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = background ?? theme.colorScheme.surfaceContainerHighest;
    final fg = foreground ?? theme.colorScheme.onSurfaceVariant;

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 16, color: fg),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(message: tooltip!, child: chip);
    }
    return chip;
  }
}
