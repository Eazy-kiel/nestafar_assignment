// lib/presentation/widgets/order_tracking/modern_placeholder.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class ModernPlaceholder extends StatelessWidget {
  const ModernPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Iconsax.gallery,
          color: AppColors.secondary.withOpacity(0.4),
          size: 32,
        ),
      ),
    );
  }
}
