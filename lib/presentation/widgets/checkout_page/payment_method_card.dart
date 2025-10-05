import "package:flutter/material.dart";
import "package:iconsax/iconsax.dart";
import "../../../core/constants/app_colors.dart";

class PaymentMethodCard extends StatelessWidget {
  final List<String> methods;
  final String selectedMethod;
  final void Function(String) onSelect;

  const PaymentMethodCard(
      {super.key,
      required this.methods,
      required this.selectedMethod,
      required this.onSelect});

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case "Cash on Delivery":
        return Iconsax.money;
      case "Card Payment":
        return Iconsax.card;
      case "Bank Transfer":
        return Iconsax.bank;
      case "Mobile Money":
        return Iconsax.mobile;
      default:
        return Iconsax.wallet_3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 6))
          ]),
      child: Column(
          children: methods.asMap().entries.map((entry) {
        final index = entry.key;
        final method = entry.value;
        final isSelected = selectedMethod == method;
        final isLast = index == methods.length - 1;
        return Column(children: [
          Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => onSelect(method),
                  borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(24) : Radius.zero,
                      bottom: isLast ? const Radius.circular(24) : Radius.zero),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(children: [
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isSelected
                                    ? const LinearGradient(colors: [
                                        AppColors.accent,
                                        Color(0xFFFFD54F)
                                      ])
                                    : null,
                                border: Border.all(
                                    color: isSelected
                                        ? AppColors.accent
                                        : AppColors.secondary.withOpacity(0.3),
                                    width: 2)),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle)))
                                : null),
                        const SizedBox(width: 16),
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent.withOpacity(0.1)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12)),
                            child: Icon(_getPaymentIcon(method),
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.secondary,
                                size: 22)),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Text(method,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: AppColors.primary))),
                        if (isSelected)
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColors.success.withOpacity(0.15),
                                    AppColors.success.withOpacity(0.08)
                                  ]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Iconsax.tick_circle5,
                                        size: 14, color: AppColors.success),
                                    SizedBox(width: 4),
                                    Text("Selected",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.success))
                                  ])),
                      ])))),
          if (!isLast)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.transparent,
                      AppColors.secondary.withOpacity(0.1),
                      Colors.transparent
                    ])))),
        ]);
      }).toList()),
    );
  }
}
