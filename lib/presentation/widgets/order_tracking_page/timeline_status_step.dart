// lib/presentation/widgets/order_tracking/timeline_status_step.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';

class TimelineStatusStep extends StatelessWidget {
  final OrderStatus status;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final int index;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const TimelineStatusStep({
    Key? key,
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.index,
    required this.pulseController,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedBuilder(
              animation: isCurrent
                  ? pulseController
                  : const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isCompleted
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getStatusColor(status),
                              _getStatusColor(status).withOpacity(0.7),
                            ],
                          )
                        : null,
                    color: isCompleted ? null : AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: _getStatusColor(status).withOpacity(0.4),
                              blurRadius: 16 * pulseAnimation.value,
                              spreadRadius: 2 * pulseAnimation.value,
                            ),
                          ]
                        : isCompleted
                            ? [
                                BoxShadow(
                                  color:
                                      _getStatusColor(status).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                  ),
                  child: isCompleted
                      ? Icon(
                          isCurrent
                              ? _getStatusIcon(status)
                              : Iconsax.tick_circle5,
                          color: AppColors.background,
                          size: 24,
                        )
                      : Icon(
                          _getStatusIcon(status),
                          color: AppColors.secondary.withOpacity(0.5),
                          size: 24,
                        ),
                );
              },
            ),
            if (!isLast)
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0.0,
                  end: isCompleted ? 1.0 : 0.0,
                ),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Container(
                    width: 3,
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getStatusColor(status),
                          isCompleted
                              ? _getStatusColor(status)
                              : AppColors.surface,
                        ],
                        stops: [value, value],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(status),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.secondary.withOpacity(0.6),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusDescription(status),
                  style: TextStyle(
                    fontSize: 13,
                    color: isCompleted
                        ? AppColors.secondary
                        : AppColors.secondary.withOpacity(0.5),
                    height: 1.4,
                  ),
                ),
                if (isCurrent && isCompleted) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'In Progress',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(status),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Iconsax.clock;
      case OrderStatus.confirmed:
        return Iconsax.tick_circle;
      case OrderStatus.preparing:
        return Iconsax.presention_chart;
      case OrderStatus.outForDelivery:
        return Iconsax.truck_fast;
      case OrderStatus.delivered:
        return Iconsax.tick_circle;
      case OrderStatus.cancelled:
        return Iconsax.close_circle;
    }
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

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Waiting for restaurant to accept';
      case OrderStatus.confirmed:
        return 'Restaurant accepted your order';
      case OrderStatus.preparing:
        return 'Chef is preparing your delicious meal';
      case OrderStatus.outForDelivery:
        return 'Delivery partner is heading your way';
      case OrderStatus.delivered:
        return 'Your order has been successfully delivered';
      case OrderStatus.cancelled:
        return 'This order has been cancelled';
    }
  }
}
