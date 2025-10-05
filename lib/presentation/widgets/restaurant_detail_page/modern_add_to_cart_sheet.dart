import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/entities/menu_item.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import 'image_placeholder.dart';

class ModernAddToCartSheet extends StatefulWidget {
  final MenuItem menuItem;
  final VoidCallback onAdded;

  const ModernAddToCartSheet({
    super.key,
    required this.menuItem,
    required this.onAdded,
  });

  @override
  State<ModernAddToCartSheet> createState() => _ModernAddToCartSheetState();
}

class _ModernAddToCartSheetState extends State<ModernAddToCartSheet>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Item Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'menu_item_${widget.menuItem.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: widget.menuItem.imageUrl.isNotEmpty
                            ? Image.network(
                                widget.menuItem.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const ImagePlaceholder(size: 32),
                              )
                            : const ImagePlaceholder(size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menuItem.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            PriceFormatter.format(widget.menuItem.price),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (widget.menuItem.description.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  widget.menuItem.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondary,
                    height: 1.5,
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // Quantity Selector
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _buildQuantityButton(
                    icon: Iconsax.minus,
                    onPressed: quantity > 1
                        ? () {
                            HapticFeedback.selectionClick();
                            setState(() => quantity--);
                          }
                        : null,
                  ),
                  Expanded(
                    child: Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Iconsax.add,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() => quantity++);
                    },
                    isPrimary: true,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Special Instructions
              const Text(
                'Special Instructions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  hintText: 'e.g., Extra spicy, No onions...',
                  hintStyle: TextStyle(
                    color: AppColors.secondary.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 28),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.read<CartBloc>().add(
                          AddToCart(
                            widget.menuItem,
                            quantity,
                            _instructionsController.text.trim().isNotEmpty
                                ? _instructionsController.text.trim()
                                : null,
                          ),
                        );
                    Navigator.of(context).pop();
                    widget.onAdded();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.background.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.tick_circle5,
                                color: AppColors.background,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Added to cart',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.shopping_cart5, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Add to Cart • ${PriceFormatter.format(widget.menuItem.price * quantity)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primary
                : (onPressed == null
                    ? AppColors.surface.withOpacity(0.5)
                    : AppColors.surface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            icon,
            color: isPrimary
                ? AppColors.background
                : (onPressed == null
                    ? AppColors.secondary.withOpacity(0.5)
                    : AppColors.primary),
            size: 22,
          ),
        ),
      ),
    );
  }
}
