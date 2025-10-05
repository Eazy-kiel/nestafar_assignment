import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class ClearCartDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const ClearCartDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: const Icon(Iconsax.warning_2,
                  color: AppColors.warning, size: 28)),
          const SizedBox(height: 20),
          const Text('Clear Cart?',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(
              'This will remove all items from your cart. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.4)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                            color: AppColors.primary.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600)))),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Clear All',
                        style: TextStyle(fontWeight: FontWeight.w600)))),
          ])
        ]),
      ),
    );
  }
}
