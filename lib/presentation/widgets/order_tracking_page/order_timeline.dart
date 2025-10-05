// lib/presentation/widgets/order_tracking/order_timeline.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';
import 'timeline_status_step.dart';

class OrderTimeline extends StatelessWidget {
  final Order order;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const OrderTimeline({
    Key? key,
    required this.order,
    required this.pulseController,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(order.status);

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
          const Text(
            'Order Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;
            final delay = index * 100;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + delay),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: TimelineStatusStep(
                      status: status,
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      isLast: index == statuses.length - 1,
                      index: index,
                      pulseController: pulseController,
                      pulseAnimation: pulseAnimation,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
