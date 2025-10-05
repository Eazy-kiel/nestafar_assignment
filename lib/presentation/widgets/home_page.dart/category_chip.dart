// lib/presentation/widgets/category_chip.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent,
                    AppColors.accent.withOpacity(0.85)
                  ],
                )
              : null,
          color: isSelected ? null : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.surface,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.05),
              blurRadius: isSelected ? 20 : 12,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.background.withOpacity(0.3)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon,
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.secondary,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
