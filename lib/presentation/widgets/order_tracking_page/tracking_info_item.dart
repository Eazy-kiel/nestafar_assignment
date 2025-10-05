// lib/presentation/widgets/order_tracking/tracking_info_item.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TrackingInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const TrackingInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.background.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
