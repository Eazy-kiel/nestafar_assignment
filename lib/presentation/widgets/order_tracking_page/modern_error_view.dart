// lib/presentation/widgets/order_tracking/modern_error_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/order_tracking/order_tracking_bloc.dart';
import '../../blocs/order_tracking/order_tracking_event.dart';
import 'modern_button.dart';

class ModernErrorView extends StatelessWidget {
  final String message;
  final String orderId;

  const ModernErrorView({
    Key? key,
    required this.message,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.close_circle,
                size: 60,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ModernButton(
              text: 'Try Again',
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.read<OrderTrackingBloc>().add(StartTracking(orderId));
              },
              backgroundColor: AppColors.primary,
              textColor: AppColors.background,
            ),
          ],
        ),
      ),
    );
  }
}
