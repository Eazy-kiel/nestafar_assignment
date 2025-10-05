// lib/presentation/widgets/order_tracking/live_tracking_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';
import 'tracking_info_item.dart';

class LiveTrackingCard extends StatelessWidget {
  final Order order;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const LiveTrackingCard({
    Key? key,
    required this.order,
    required this.pulseController,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.6),
                                blurRadius: 16 * pulseAnimation.value,
                                spreadRadius: 2 * pulseAnimation.value,
                              ),
                            ],
                          ),
                          child: Icon(
                            order.status == OrderStatus.outForDelivery
                                ? Iconsax.truck_fast
                                : Iconsax.presention_chart,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.status == OrderStatus.outForDelivery
                                ? 'Driver on the way'
                                : 'Preparing your order',
                            style: const TextStyle(
                              color: AppColors.background,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.status == OrderStatus.outForDelivery
                                ? 'Your food will arrive soon'
                                : 'Chef is cooking with love',
                            style: TextStyle(
                              color: AppColors.background.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const TrackingInfoItem(
                        icon: Iconsax.timer_1,
                        label: 'Est. Time',
                        value: '25-30 min',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.background.withOpacity(0.3),
                      ),
                      const TrackingInfoItem(
                        icon: Iconsax.location,
                        label: 'Distance',
                        value: '2.5 km',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
