import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class CartAppBar extends StatelessWidget {
  final bool showShadow;
  final int itemCount;
  final VoidCallback onBack;
  final VoidCallback onClear;

  const CartAppBar({
    super.key,
    required this.showShadow,
    required this.itemCount,
    required this.onBack,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: showShadow
            ? [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ]
            : [],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              _buildBackButton(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Cart',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 2),
                    TweenAnimationBuilder<int>(
                      duration: const Duration(milliseconds: 400),
                      tween: IntTween(begin: 0, end: itemCount),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                  '$value ${value == 1 ? 'item' : 'items'}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              _buildClearButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.08))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onBack,
          child: const Padding(
              padding: EdgeInsets.all(10),
              child:
                  Icon(Iconsax.arrow_left, color: AppColors.primary, size: 22)),
        ),
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onClear,
          child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Iconsax.trash, color: AppColors.error, size: 20)),
        ),
      ),
    );
  }
}
