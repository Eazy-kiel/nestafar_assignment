// lib/presentation/widgets/order_tracking/order_items_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/entities/order.dart';
import 'order_item_row.dart';
import 'price_row.dart';

class OrderItemsCard extends StatelessWidget {
  final Order order;

  const OrderItemsCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.bag_2,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...order.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return OrderItemRow(
              item: item,
              index: index,
            );
          }),
          const SizedBox(height: 8),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.0),
                  AppColors.secondary.withOpacity(0.2),
                  AppColors.secondary.withOpacity(0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          PriceRow(label: 'Subtotal', amount: order.subtotal),
          const SizedBox(height: 12),
          PriceRow(label: 'Delivery Fee', amount: order.deliveryFee),
          const SizedBox(height: 12),
          if (order.taxAmount > 0) ...[
            PriceRow(label: 'Tax', amount: order.taxAmount),
            const SizedBox(height: 12),
          ],
          if (order.discount > 0) ...[
            PriceRow(
                label: 'Discount', amount: -order.discount, isDiscount: true),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  PriceFormatter.format(order.total),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
