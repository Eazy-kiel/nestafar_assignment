// lib/presentation/widgets/order_tracking/modern_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/order_tracking/order_tracking_bloc.dart';
import '../../blocs/order_tracking/order_tracking_event.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String orderId;

  const ModernAppBar({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Iconsax.arrow_left, color: AppColors.primary),
            onPressed: () {
              context.read<OrderTrackingBloc>().add(StopTracking());
              context.pop();
            },
          ),
        ),
      ),
      title: const Text(
        'Track Order',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Iconsax.refresh, color: AppColors.primary),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.read<OrderTrackingBloc>().add(StartTracking(orderId));
              },
            ),
          ),
        ),
      ],
    );
  }
}
