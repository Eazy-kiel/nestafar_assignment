// lib/presentation/widgets/cart_fab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_colors.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';

class CartFab extends StatelessWidget {
  final Animation<Offset> fabSlide;
  final Animation<double> fabScale;
  final VoidCallback onOpenCart;

  const CartFab({
    Key? key,
    required this.fabSlide,
    required this.fabScale,
    required this.onOpenCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, cartState) {
      return Positioned(
        right: 24,
        bottom: 24,
        child: SlideTransition(
          position: fabSlide,
          child: ScaleTransition(
            scale: fabScale,
            child: GestureDetector(
              onTap: onOpenCart,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Iconsax.shopping_cart5,
                            color: AppColors.background, size: 28),
                        if (cartState.itemCount > 0)
                          Positioned(
                            right: -8,
                            top: -8,
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 400),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.accent,
                                          AppColors.accent.withOpacity(0.9),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.accent.withOpacity(0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 22,
                                      minHeight: 22,
                                    ),
                                    child: Text(
                                      cartState.itemCount > 99
                                          ? '99+'
                                          : cartState.itemCount.toString(),
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    if (cartState.itemCount > 0) ...[
                      const SizedBox(width: 16),
                      Container(
                        width: 2,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background.withOpacity(0.5),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'View Cart',
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '${cartState.itemCount} item${cartState.itemCount != 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Iconsax.arrow_right_3,
                            color: AppColors.background, size: 18),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
