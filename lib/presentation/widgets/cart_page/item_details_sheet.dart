import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';

class ItemDetailsSheet extends StatelessWidget {
  final dynamic cartItem;
  const ItemDetailsSheet({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        Hero(
            tag: 'cart_item_detail_${cartItem.menuItem.id}',
            child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    image: cartItem.menuItem.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(cartItem.menuItem.imageUrl!),
                            fit: BoxFit.cover)
                        : null))),
        const SizedBox(height: 20),
        Text(cartItem.menuItem.name,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary)),
        const SizedBox(height: 8),
        if (cartItem.menuItem.description != null)
          Text(cartItem.menuItem.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.5)),
        const SizedBox(height: 20),
        Text(PriceFormatter.format(cartItem.menuItem.price),
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.accent)),
        const SizedBox(height: 24),
      ]),
    );
  }
}
