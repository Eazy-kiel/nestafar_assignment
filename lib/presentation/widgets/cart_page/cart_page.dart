// === File: lib/presentation/pages/cart_page.dart ===
// Refactored CartPage: keeps the same behavior and animations but delegates
// UI pieces to smaller widgets under lib/presentation/widgets/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../../core/constants/app_colors.dart';
import 'cart_app_bar.dart';
import 'cart_item_card.dart';
import '../checkout_page/order_summary_card.dart';
import 'empty_cart_widget.dart';
import 'clear_cart_dialog.dart';
import 'item_details_sheet.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

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
            return EmptyCartWidget(onBrowse: () => context.go('/'));
          }

          return Stack(
            children: [
              Column(
                children: [
                  CartAppBar(
                    showShadow: _showShadow,
                    itemCount: state.items.length,
                    onBack: () => context.pop(),
                    onClear: () => _showClearCartDialog(context),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 200),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.items[index];
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: CartItemCard(
                            cartItem: cartItem,
                            onRemove: (id, name) {
                              context.read<CartBloc>().add(RemoveFromCart(id));
                              _showSnackBar(context, '$name removed from cart');
                            },
                            onUpdateQuantity: (id, qty) {
                              context
                                  .read<CartBloc>()
                                  .add(UpdateCartItem(id, qty));
                            },
                            onTapDetails: (item) =>
                                _showItemDetails(context, item),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position:
                      Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                          .animate(_summarySlideAnimation),
                  child: FadeTransition(
                    opacity: _summaryFadeAnimation,
                    child: OrderSummaryCard(
                      subtotal: state.subtotal,
                      deliveryFee: state.deliveryFee,
                      total: state.total,
                      onCheckout: () {
                        HapticFeedback.mediumImpact();
                        context.push('/checkout');
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showItemDetails(BuildContext context, dynamic cartItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ItemDetailsSheet(cartItem: cartItem),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (_) => ClearCartDialog(onConfirm: () {
        context.read<CartBloc>().add(ClearCart());
        Navigator.of(context).pop();
        _showSnackBar(context, 'Cart cleared successfully');
      }),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
