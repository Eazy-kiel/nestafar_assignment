import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nestafar_assignment/presentation/blocs/cart/cart_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/entities/cart_item.dart';

class OrderSummaryPanel extends StatelessWidget {
  final CartState cartState;
  final bool expanded;
  final VoidCallback onToggle;
  final List<Map<String, dynamic>> tipOptions;
  final int selectedTipIndex;
  final void Function(int) onTipSelected;

  const OrderSummaryPanel(
      {Key? key,
      required this.cartState,
      required this.expanded,
      required this.onToggle,
      required this.tipOptions,
      required this.selectedTipIndex,
      required this.onTipSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 6))
          ]),
      child: Column(children: [
        InkWell(
          onTap: onToggle,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent.withOpacity(0.08),
                      AppColors.accent.withOpacity(0.02)
                    ]),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24))),
            child: Row(children: [
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Iconsax.receipt_item,
                      color: AppColors.accent, size: 22)),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Order Summary',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text('${0} items',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500))
                  ])),
              Text(PriceFormatter.format(cartState.subtotal),
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              const SizedBox(width: 12),
              AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Iconsax.arrow_down_1,
                          size: 18, color: AppColors.secondary))),
            ]),
          ),
        ),
        if (expanded)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 12),
                ...cartState.items.map((item) => _orderRow(item)).toList(),
                const SizedBox(height: 12),
                _buildPriceRow('Subtotal', cartState.subtotal),
                const SizedBox(height: 12),
                _buildPriceRow('Delivery Fee', cartState.deliveryFee),
              ])),
        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _orderRow(CartItem item) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.accent.withOpacity(0.08)
                  ]),
                  borderRadius: BorderRadius.circular(14)),
              child: Center(
                  child: Text('${item.quantity}×',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent)))),
          const SizedBox(width: 16),
          Expanded(
              child: Text(item.menuItem.name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary))),
          const SizedBox(width: 12),
          Text(PriceFormatter.format(item.totalPrice),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ]));
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary)),
      Text(PriceFormatter.format(amount),
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary)),
    ]);
  }
}
