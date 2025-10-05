import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class CheckoutEmpty extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  const CheckoutEmpty(
      {Key? key, required this.scaleAnimation, required this.fadeAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.accent.withOpacity(0.15),
                            AppColors.accent.withOpacity(0.05)
                          ]),
                      shape: BoxShape.circle),
                  child: Icon(Iconsax.shopping_cart,
                      size: 80, color: AppColors.accent.withOpacity(0.6))),
              const SizedBox(height: 32),
              const Text('Your cart is empty',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 12),
              const Text('Add some delicious items to get started',
                  style: TextStyle(fontSize: 15, color: AppColors.secondary)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Iconsax.shop),
                  label: const Text('Browse Menu'))
            ],
          ),
        ),
      ),
    );
  }
}
