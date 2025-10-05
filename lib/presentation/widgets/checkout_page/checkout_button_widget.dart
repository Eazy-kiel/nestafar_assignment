import "package:flutter/material.dart";
import "package:iconsax/iconsax.dart";
import "../../../core/constants/app_colors.dart";
import "../../../core/utils/price_formatter.dart";
import "../../blocs/cart/cart_state.dart";

class CheckoutButtonWidget extends StatelessWidget {
  final CartState cartState;
  final double Function(CartState) calculateTotal;
  final void Function(CartState) onPlaceOrder;

  const CheckoutButtonWidget(
      {super.key,
      required this.cartState,
      required this.calculateTotal,
      required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 40,
                offset: const Offset(0, -12))
          ]),
      child: SafeArea(
          top: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.secondary.withOpacity(0.2),
                      AppColors.secondary.withOpacity(0.4),
                      AppColors.secondary.withOpacity(0.2)
                    ]),
                    borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 20),
            Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, Color(0xFF2A2A2A)]),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 12))
                    ]),
                child: ElevatedButton(
                    onPressed: () => onPlaceOrder(cartState),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.background,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.tick_circle5, size: 26),
                          const SizedBox(width: 14),
                          const Text("Place Order",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3)),
                          const Spacer(),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColors.accent.withOpacity(0.3),
                                    AppColors.accent.withOpacity(0.2)
                                  ]),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Text(
                                  PriceFormatter.format(
                                      calculateTotal(cartState)),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.accent)))
                        ]))),
          ])),
    );
  }
}
