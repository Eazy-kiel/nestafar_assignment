// lib/presentation/widgets/order_tracking/animated_status_badge.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';

class AnimatedStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const AnimatedStatusBadge({
    Key? key,
    required this.status,
    required this.pulseController,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive =
        status != OrderStatus.delivered && status != OrderStatus.cancelled;

    return AnimatedBuilder(
      animation: isActive ? pulseAnimation : const AlwaysStoppedAnimation(1.0),
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(status).withOpacity(0.4),
                  blurRadius: isActive ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isActive)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  _getStatusText(status),
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.confirmed:
        return AppColors.accent;
      case OrderStatus.preparing:
        return AppColors.accent;
      case OrderStatus.outForDelivery:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'On The Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
