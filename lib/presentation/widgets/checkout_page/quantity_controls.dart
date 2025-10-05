import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecreaseOrRemove;

  const QuantityControls(
      {Key? key,
      required this.quantity,
      required this.onIncrease,
      required this.onDecreaseOrRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.08), width: 1)),
      child: Column(
        children: [
          _buildQuantityButton(icon: Iconsax.add, onTap: onIncrease),
          Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                  child: Text('$quantity',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)))),
          _buildQuantityButton(
              icon: quantity > 1 ? Iconsax.minus : Iconsax.trash,
              onTap: onDecreaseOrRemove,
              isDecrease: true),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon,
      required VoidCallback onTap,
      bool isDecrease = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon,
                color: isDecrease ? AppColors.error : AppColors.primary,
                size: 18)),
      ),
    );
  }
}
