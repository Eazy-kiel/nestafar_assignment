import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';

class FloatingCartButton extends StatelessWidget {
  final AnimationController animationController;
  final GlobalKey cartKey;
  final bool cartPulse;

  const FloatingCartButton({
    super.key,
    required this.animationController,
    required this.cartKey,
    required this.cartPulse,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 20,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final hasItems = cartState.itemCount > 0;

          return ScaleTransition(
            scale: animationController,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.push('/cart');
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    key: cartKey,
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: hasItems ? 24 : 20,
                      vertical: hasItems ? 18 : 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hasItems
                            ? [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.8)
                              ]
                            : [AppColors.primary, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color:
                              AppColors.accent.withOpacity(cartPulse ? 0.4 : 0),
                          blurRadius: cartPulse ? 30 : 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Iconsax.shopping_cart5,
                              color: AppColors.background,
                              size: 24,
                            ),
                            if (hasItems)
                              Positioned(
                                right: -8,
                                top: -8,
                                child: AnimatedScale(
                                  scale: cartPulse ? 1.3 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.background,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.accent.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Text(
                                      cartState.itemCount.toString(),
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (hasItems) ...[
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'View Cart',
                                style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                PriceFormatter.format(cartState.total),
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.background,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
