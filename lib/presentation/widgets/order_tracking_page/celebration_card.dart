// lib/presentation/widgets/order_tracking/celebration_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';
import 'modern_button.dart';

class CelebrationCard extends StatelessWidget {
  final Order order;
  final AnimationController celebrationController;

  const CelebrationCard({
    Key? key,
    required this.order,
    required this.celebrationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: celebrationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (celebrationController.value * 0.05),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.success,
                  AppColors.success.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.background.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Iconsax.tick_circle5,
                            color: AppColors.success,
                            size: 48,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  '🎉 Order Delivered!',
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Hope you enjoyed your meal from\n${order.restaurant.name}',
                  style: TextStyle(
                    color: AppColors.background.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ModernButton(
                        text: 'Rate Order',
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          // Show rating dialog
                        },
                        backgroundColor: AppColors.background,
                        textColor: AppColors.success,
                        icon: Iconsax.star5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ModernButton(
                        text: 'Order Again',
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.go('/');
                        },
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.background,
                        icon: Iconsax.refresh,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
