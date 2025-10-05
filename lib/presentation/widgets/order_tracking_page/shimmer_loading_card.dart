// lib/presentation/widgets/order_tracking/shimmer_loading_card.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ShimmerLoadingCard extends StatelessWidget {
  final double height;
  final AnimationController pulseController;

  const ShimmerLoadingCard({
    Key? key,
    required this.height,
    required this.pulseController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.surface,
                AppColors.surface.withOpacity(0.5),
                AppColors.surface,
              ],
              stops: [
                0.0,
                pulseController.value,
                1.0,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
