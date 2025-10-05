import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ModernInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sublabel;
  final Color color;
  final bool isRating;

  const ModernInfoPill({
    super.key,
    required this.icon,
    required this.label,
    this.sublabel,
    required this.color,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isRating ? AppColors.accent.withOpacity(0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRating
                ? AppColors.accent.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isRating ? color : AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (sublabel != null) ...[
              const SizedBox(width: 2),
              Text(
                sublabel!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
