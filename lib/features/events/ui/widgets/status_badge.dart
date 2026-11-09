import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final bool filled;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.filled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? AppColors.white : AppColors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: filled ? AppColors.black : AppColors.gray300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
