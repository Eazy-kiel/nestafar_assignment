// lib/presentation/pages/cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _summaryController;
  late AnimationController _listController;
  late Animation<double> _summarySlideAnimation;
  late Animation<double> _summaryFadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();

    _summaryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _summarySlideAnimation = CurvedAnimation(
      parent: _summaryController,
      curve: Curves.easeOutCubic,
    );

    _summaryFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _summaryController, curve: Curves.easeIn),
    );

    _summaryController.forward();
    _listController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_showShadow) {
        setState(() => _showShadow = true);
      } else if (_scrollController.offset <= 10 && _showShadow) {
        setState(() => _showShadow = false);
      }
    });
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _listController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _buildEmptyState(context);
          }

          return Stack(
            children: [
              Column(
                children: [
                  _buildCustomAppBar(context, state),
                  Expanded(
                    child: _buildCartItems(context, state),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildAnimatedOrderSummary(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, CartState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: _showShadow
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              _buildBackButton(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Cart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _buildItemCounter(state),
                  ],
                ),
              ),
              _buildClearButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Iconsax.arrow_left,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCounter(CartState state) {
    return TweenAnimationBuilder<int>(
      duration: const Duration(milliseconds: 400),
      tween: IntTween(begin: 0, end: state.items.length),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value ${value == 1 ? 'item' : 'items'}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showClearCartDialog(context),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Iconsax.trash,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, CartState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 200),
      physics: const BouncingScrollPhysics(),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        return _buildAnimatedCartItem(
          context,
          state.items[index],
          index,
        );
      },
    );
  }

  Widget _buildAnimatedCartItem(
    BuildContext context,
    dynamic cartItem,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: _buildCartItemCard(context, cartItem),
    );
  }

  Widget _buildCartItemCard(BuildContext context, dynamic cartItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(cartItem.menuItem.id),
        direction: DismissDirection.endToStart,
        background: _buildDismissBackground(),
        confirmDismiss: (direction) => _confirmDismiss(context),
        onDismissed: (direction) {
          context.read<CartBloc>().add(RemoveFromCart(cartItem.menuItem.id));
          _showSnackBar(context, '${cartItem.menuItem.name} removed from cart');
        },
        child: _buildItemCard(context, cartItem),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Iconsax.trash,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, dynamic cartItem) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showItemDetails(context, cartItem),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildItemImage(cartItem),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildItemDetails(context, cartItem),
                  ),
                  _buildQuantityControls(context, cartItem),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage(dynamic cartItem) {
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
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: cartItem.menuItem.imageUrl == null
            ? const Icon(
                Iconsax.gallery,
                color: AppColors.secondary,
                size: 32,
              )
            : null,
      ),
    );
  }

  Widget _buildItemDetails(BuildContext context, dynamic cartItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.menuItem.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        if (cartItem.menuItem.description != null) ...[
          Text(
            cartItem.menuItem.description!,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.secondary.withOpacity(0.8),
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],
        _buildPriceTag(cartItem),
      ],
    );
  }

  Widget _buildPriceTag(dynamic cartItem) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: cartItem.menuItem.price),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.2),
                AppColors.accent.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            PriceFormatter.format(value),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityControls(BuildContext context, dynamic cartItem) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildQuantityButton(
            icon: Iconsax.add,
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<CartBloc>().add(
                    UpdateCartItem(
                      cartItem.menuItem.id,
                      cartItem.quantity + 1,
                    ),
                  );
            },
          ),
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: TweenAnimationBuilder<int>(
                duration: const Duration(milliseconds: 300),
                tween:
                    IntTween(begin: cartItem.quantity, end: cartItem.quantity),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          _buildQuantityButton(
            icon: cartItem.quantity > 1 ? Iconsax.minus : Iconsax.trash,
            onTap: () {
              HapticFeedback.lightImpact();
              if (cartItem.quantity > 1) {
                context.read<CartBloc>().add(
                      UpdateCartItem(
                        cartItem.menuItem.id,
                        cartItem.quantity - 1,
                      ),
                    );
              } else {
                context.read<CartBloc>().add(
                      RemoveFromCart(cartItem.menuItem.id),
                    );
              }
            },
            isDecrease: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDecrease = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: isDecrease ? AppColors.error : AppColors.primary,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedOrderSummary(BuildContext context, CartState state) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_summarySlideAnimation),
      child: FadeTransition(
        opacity: _summaryFadeAnimation,
        child: _buildOrderSummaryCard(context, state),
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, CartState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Subtotal',
                  state.subtotal,
                  isSubtotal: true,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  'Delivery Fee',
                  state.deliveryFee,
                  icon: Iconsax.truck_fast,
                ),
                const SizedBox(height: 16),
                _buildDivider(),
                const SizedBox(height: 16),
                _buildTotalRow(state.total),
                const SizedBox(height: 20),
                _buildCheckoutButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isSubtotal = false,
    IconData? icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.secondary,
                fontWeight: isSubtotal ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: amount),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Text(
              PriceFormatter.format(value),
              style: TextStyle(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.w500,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.secondary.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: total),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.accent, AppColors.warning],
                ).createShader(bounds),
                child: Text(
                  PriceFormatter.format(value),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push('/checkout');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 12),
            Icon(
              Iconsax.arrow_right_1,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent.withOpacity(0.2),
                      AppColors.accent.withOpacity(0.05),
                    ],
                  ),
                ),
                child: const Icon(
                  Iconsax.shopping_cart,
                  size: 80,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add some delicious items\nto get started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.secondary.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            _buildBrowseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.go('/');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.shop, size: 20),
            SizedBox(width: 12),
            Text(
              'Browse Restaurants',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDismiss(BuildContext context) async {
    HapticFeedback.mediumImpact();
    return await showDialog<bool>(
      context: context,
      builder: (context) => _buildConfirmDialog(context),
    );
  }

  Widget _buildConfirmDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.trash,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Remove Item?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to remove this item from your cart?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondary.withOpacity(0.8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.warning_2,
                  color: AppColors.warning,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Clear Cart?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will remove all items from your cart. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        context.read<CartBloc>().add(ClearCart());
                        Navigator.of(context).pop();
                        _showSnackBar(context, 'Cart cleared successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, dynamic cartItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildItemDetailsSheet(cartItem),
    );
  }

  Widget _buildItemDetailsSheet(dynamic cartItem) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
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
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            cartItem.menuItem.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          if (cartItem.menuItem.description != null)
            Text(
              cartItem.menuItem.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondary.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            PriceFormatter.format(cartItem.menuItem.price),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Iconsax.tick_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
  }
}
