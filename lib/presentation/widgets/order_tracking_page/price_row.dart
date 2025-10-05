// lib/presentation/widgets/order_tracking/price_row.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';

class PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDiscount;

  const PriceRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isDiscount = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          PriceFormatter.format(amount.abs()),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.success : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
