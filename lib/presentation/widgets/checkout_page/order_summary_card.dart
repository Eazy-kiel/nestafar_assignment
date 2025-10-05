import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  final VoidCallback onCheckout;

  const OrderSummaryCard(
      {Key? key,
      required this.subtotal,
      required this.deliveryFee,
      required this.total,
      required this.onCheckout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, -8))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(children: [
              _buildSummaryRow('Subtotal', subtotal, isSubtotal: true),
              const SizedBox(height: 12),
              _buildSummaryRow('Delivery Fee', deliveryFee,
                  icon: Iconsax.truck_fast),
              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildTotalRow(total),
              const SizedBox(height: 20),
              _buildCheckoutButton(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isSubtotal = false, IconData? icon}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8)
        ],
        Text(label,
            style: TextStyle(
                fontSize: 15,
                color: AppColors.secondary,
                fontWeight: isSubtotal ? FontWeight.w500 : FontWeight.normal)),
      ]),
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: amount),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Text(PriceFormatter.format(value),
            style: TextStyle(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.w500)),
      ),
    ]);
  }

  Widget _buildDivider() {
    return Container(
        height: 1,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.transparent,
          AppColors.secondary.withOpacity(0.2),
          Colors.transparent
        ])));
  }

  Widget _buildTotalRow(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.accent.withOpacity(0.05)
          ]),
          borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Total Amount',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary)),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: total),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.accent, AppColors.warning])
                  .createShader(bounds),
              child: Text(PriceFormatter.format(value),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            );
          },
        ),
      ]),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8))
      ]),
      child: ElevatedButton(
        onPressed: onCheckout,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 16)),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Proceed to Checkout',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
          SizedBox(width: 12),
          Icon(Iconsax.arrow_right_1, size: 20)
        ]),
      ),
    );
  }
}
