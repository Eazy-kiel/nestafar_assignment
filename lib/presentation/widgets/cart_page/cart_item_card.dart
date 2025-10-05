import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import 'dismiss_background.dart';
import '../checkout_page/quantity_controls.dart';
import 'confirm_remove_dialog.dart';

class CartItemCard extends StatelessWidget {
  final dynamic cartItem;
  final void Function(String id, String name) onRemove;
  final void Function(String id, int qty) onUpdateQuantity;
  final void Function(dynamic item) onTapDetails;

  const CartItemCard(
      {Key? key,
      required this.cartItem,
      required this.onRemove,
      required this.onUpdateQuantity,
      required this.onTapDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(cartItem.menuItem.id),
        direction: DismissDirection.endToStart,
        background: const DismissBackground(),
        confirmDismiss: (direction) => _confirmDismiss(context),
        onDismissed: (direction) =>
            onRemove(cartItem.menuItem.id, cartItem.menuItem.name),
        child: _buildItemCard(context),
      ),
    );
  }

  Future<bool?> _confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
        context: context, builder: (context) => const ConfirmRemoveDialog());
  }

  Widget _buildItemCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AppColors.primary.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTapDetails(cartItem),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildItemImage(),
                  const SizedBox(width: 16),
                  Expanded(child: _buildItemDetails()),
                  QuantityControls(
                    quantity: cartItem.quantity,
                    onIncrease: () => onUpdateQuantity(
                        cartItem.menuItem.id, cartItem.quantity + 1),
                    onDecreaseOrRemove: () {
                      if (cartItem.quantity > 1) {
                        onUpdateQuantity(
                            cartItem.menuItem.id, cartItem.quantity - 1);
                      } else {
                        onRemove(cartItem.menuItem.id, cartItem.menuItem.name);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return Hero(
      tag: 'cart_item_${cartItem.menuItem.id}',
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          image: cartItem.menuItem.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(cartItem.menuItem.imageUrl!),
                  fit: BoxFit.cover)
              : null,
        ),
        child: cartItem.menuItem.imageUrl == null
            ? const Icon(Iconsax.gallery, color: AppColors.secondary, size: 32)
            : null,
      ),
    );
  }

  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cartItem.menuItem.name,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        if (cartItem.menuItem.description != null) ...[
          Text(cartItem.menuItem.description!,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
        ],
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: 0.0, end: cartItem.menuItem.price),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.accent.withOpacity(0.2),
                    AppColors.accent.withOpacity(0.1)
                  ]),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(PriceFormatter.format(value),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            );
          },
        ),
      ],
    );
  }
}
