import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/entities/restaurant.dart';
import 'modern_info_pill.dart';

class RestaurantInfoCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantInfoCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: -0.8,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      restaurant.cuisine,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),

          const SizedBox(height: 20),

          // Info Pills
          Row(
            children: [
              ModernInfoPill(
                icon: Iconsax.star5,
                label: '${restaurant.rating}',
                sublabel: '(${restaurant.reviewCount})',
                color: AppColors.accent,
                isRating: true,
              ),
              const SizedBox(width: 10),
              ModernInfoPill(
                icon: Iconsax.clock,
                label: '${restaurant.deliveryTime}',
                sublabel: 'min',
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              ModernInfoPill(
                icon: Iconsax.truck_fast,
                label: PriceFormatter.format(restaurant.deliveryFee),
                sublabel: 'fee',
                color: AppColors.primary,
              ),
            ],
          ),

          // Tags
          if (restaurant.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: restaurant.tags.map((tag) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    if (!restaurant.isOpen) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.error.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Text(
          'Closed',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Open',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
