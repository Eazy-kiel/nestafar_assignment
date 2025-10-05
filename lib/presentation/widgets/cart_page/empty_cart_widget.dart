import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback onBrowse;
  const EmptyCartWidget({Key? key, required this.onBrowse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accent.withOpacity(0.2),
                          AppColors.accent.withOpacity(0.05)
                        ])),
                child: const Icon(Iconsax.shopping_cart,
                    size: 80, color: AppColors.secondary)),
          ),
          const SizedBox(height: 32),
          const Text('Your cart is empty',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          const SizedBox(height: 12),
          Text('Add some delicious items\\nto get started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.5)),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6))
                ]),
            child: ElevatedButton(
                onPressed: onBrowse,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.shop, size: 20),
                      SizedBox(width: 12),
                      Text('Browse Restaurants',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3))
                    ])),
          ),
        ]),
      ),
    );
  }
}
