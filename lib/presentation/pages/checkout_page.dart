// === File: lib/presentation/pages/checkout_page.dart ===
// Refactored CheckoutPage: slim coordinator that delegates UI pieces to widgets
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nestafar_assignment/presentation/widgets/checkout_page/section_header.dart';
import 'dart:ui';

import '../blocs/cart/cart_event.dart';
import '../blocs/checkout/checkout_bloc.dart';
import '../blocs/checkout/checkout_event.dart';
import '../blocs/checkout/checkout_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';

import '../../core/constants/app_colors.dart';

import '../../domain/entities/restaurant.dart';

import '../widgets/checkout_page/checkout_loading.dart';
import '../widgets/checkout_page/checkout_empty.dart';
import '../widgets/checkout_page/order_summary_panel.dart';
import '../widgets/checkout_page/delivery_address_card.dart';
import '../widgets/checkout_page/delivery_time_card.dart';
import '../widgets/checkout_page/tip_section.dart';
import '../widgets/checkout_page/special_instructions_card.dart';
import '../widgets/checkout_page/payment_method_card.dart';
import '../widgets/checkout_page/promo_code_widget.dart';
import '../widgets/checkout_page/checkout_button_widget.dart';
import '../widgets/checkout_page/success_dialog_widget.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _promoController = TextEditingController();
  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _orderSummaryExpanded = true;
  bool _saveAddress = false;
  int _selectedTipIndex = -1;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  final List<String> _paymentMethods = [
    'Cash on Delivery',
    'Card Payment',
    'Bank Transfer',
    'Mobile Money',
  ];

  final List<Map<String, dynamic>> _tipOptions = [
    {'label': '₦100', 'value': 100.0},
    {'label': '₦200', 'value': 200.0},
    {'label': '₦500', 'value': 500.0},
    {'label': 'Custom', 'value': 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCheckoutData();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(_shimmerController);

    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  void _loadCheckoutData() {
    final checkoutState = context.read<CheckoutBloc>().state;
    if (checkoutState is CheckoutInitial) {
      _addressController.text = checkoutState.deliveryAddress;
      _instructionsController.text = checkoutState.specialInstructions;
      _selectedPaymentMethod = checkoutState.paymentMethod;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    _promoController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _scale_controller_safeDispose();
    _shimmerController.dispose();
    super.dispose();
  }

  // helper to avoid accidental naming mistakes in dispose (keeps parity with init)
  // ignore: non_constant_identifier_names
  void _scale_controller_safeDispose() {
    try {
      _scaleController.dispose();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: _handleCheckoutState,
        builder: (context, checkoutState) {
          if (checkoutState is CheckoutLoading) {
            // <-- changed to CheckoutLoadingWidget to avoid collision with CheckoutLoading state
            return CheckoutLoadingWidget(shimmerAnimation: _shimmerAnimation);
          }

          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState.isEmpty) {
                return CheckoutEmpty(
                    scaleAnimation: _scaleAnimation,
                    fadeAnimation: _fadeAnimation);
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionHeader(
                                    title: 'Order Details',
                                    icon: Iconsax.receipt_item),
                                const SizedBox(height: 16),
                                OrderSummaryPanel(
                                  cartState: cartState,
                                  expanded: _orderSummaryExpanded,
                                  onToggle: () {
                                    setState(() => _orderSummaryExpanded =
                                        !_orderSummaryExpanded);
                                    HapticFeedback.selectionClick();
                                  },
                                  tipOptions: _tipOptions,
                                  selectedTipIndex: _selectedTipIndex,
                                  onTipSelected: (i) =>
                                      setState(() => _selectedTipIndex = i),
                                ),
                                const SizedBox(height: 28),
                                const SectionHeader(
                                    title: 'Delivery Address',
                                    icon: Iconsax.location),
                                const SizedBox(height: 16),
                                DeliveryAddressCard(
                                  addressController: _addressController,
                                  saveAddress: _saveAddress,
                                  onToggleSave: () => setState(
                                      () => _saveAddress = !_saveAddress),
                                  onAddressChanged: (v) => context
                                      .read<CheckoutBloc>()
                                      .add(UpdateDeliveryAddress(v)),
                                ),
                                const SizedBox(height: 28),
                                const SectionHeader(
                                    title: 'Delivery Time',
                                    icon: Iconsax.clock),
                                const SizedBox(height: 16),
                                const DeliveryTimeCard(),
                                const SizedBox(height: 28),
                                const SectionHeader(
                                    title: 'Add a Tip', icon: Iconsax.heart),
                                const SizedBox(height: 16),
                                TipSection(
                                  tipOptions: _tipOptions,
                                  selectedIndex: _selectedTipIndex,
                                  onSelect: (i) =>
                                      setState(() => _selectedTipIndex = i),
                                ),
                                const SizedBox(height: 28),
                                const SectionHeader(
                                    title: 'Special Instructions',
                                    icon: Iconsax.note_text),
                                const SizedBox(height: 16),
                                SpecialInstructionsCard(
                                  controller: _instructionsController,
                                  onChanged: (v) => context
                                      .read<CheckoutBloc>()
                                      .add(UpdateSpecialInstructions(v)),
                                ),
                                const SizedBox(height: 28),
                                const SectionHeader(
                                    title: 'Payment Method',
                                    icon: Iconsax.card_tick),
                                const SizedBox(height: 16),
                                PaymentMethodCard(
                                  methods: _paymentMethods,
                                  selectedMethod: _selectedPaymentMethod,
                                  onSelect: (m) {
                                    setState(() => _selectedPaymentMethod = m);
                                    context
                                        .read<CheckoutBloc>()
                                        .add(UpdatePaymentMethod(m));
                                  },
                                ),
                                const SizedBox(height: 28),
                                PromoCodeWidget(
                                    controller: _promo_controller_safeUse()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CheckoutButtonWidget(
                    cartState: context.read<CartBloc>().state,
                    calculateTotal: (state) {
                      double total = state.total;
                      if (_selectedTipIndex >= 0 && _selectedTipIndex < 3) {
                        total += _tipOptions[_selectedTipIndex]['value'];
                      }
                      return total;
                    },
                    onPlaceOrder: (cartState) => _place_order_safe(cartState),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // small wrappers to keep code robust when pasting into various projects
  // ignore: non_constant_identifier_names
  TextEditingController _promo_controller_safeUse() => _promoController;
  // ignore: non_constant_identifier_names
  void _place_order_safe(CartState cartState) => _placeOrder(cartState);

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Iconsax.arrow_left,
                color: AppColors.primary, size: 20),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
          ),
        ),
      ),
      title: const Text('Checkout',
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5)),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  void _handleCheckoutState(BuildContext context, CheckoutState state) {
    if (state is CheckoutSuccess) {
      HapticFeedback.mediumImpact();
      _showSuccessAnimation(context, state);
    } else if (state is CheckoutError) {
      HapticFeedback.vibrate();
      _showErrorSnackbar(context, state.message);
    }
  }

  void _navigateToTracking(String orderId) {
    if (!mounted) return;
    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) rootNav.pop();
    ScaffoldMessenger.of(context).clearSnackBars();
    context.go('/order-tracking/$orderId');
  }

  void _showSuccessAnimation(BuildContext context, CheckoutSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.primary.withOpacity(0.8),
      builder: (dialogCtx) => SuccessDialog(
        onComplete: () {
          if (!mounted) return;
          context.read<CartBloc>().add(ClearCart());
          _navigateToTracking(state.order.id);
        },
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Iconsax.info_circle,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(message,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  double _calculateTotal(CartState cartState) {
    double total = cartState.total;
    if (_selectedTipIndex >= 0 && _selectedTipIndex < 3) {
      total += _tipOptions[_selectedTipIndex]['value'];
    }
    return total;
  }

  void _placeOrder(CartState cartState) {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackbar(context, 'Please fill in all required fields');
      return;
    }

    HapticFeedback.heavyImpact();

    if (cartState.items.isNotEmpty) {
      final checkoutBloc = context.read<CheckoutBloc>();

      final mockRestaurant = cartState.items.first.menuItem.id.startsWith('1_')
          ? _getMockRestaurant('1')
          : _getMockRestaurant('2');

      checkoutBloc.placeOrderWithData(
        restaurant: mockRestaurant,
        items: cartState.items,
        subtotal: cartState.subtotal,
        deliveryFee: cartState.deliveryFee,
        total: _calculateTotal(cartState),
      );
    }
  }

  Restaurant _getMockRestaurant(String id) {
    switch (id) {
      case '1':
        return const Restaurant(
          id: '1',
          name: 'Mama\'s Kitchen',
          imageUrl:
              'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
          cuisine: 'Nigerian',
          rating: 4.8,
          reviewCount: 324,
          deliveryTime: 25,
          deliveryFee: 500.0,
          isOpen: true,
          tags: ['Popular', 'Fast Delivery'],
        );
      case '2':
        return const Restaurant(
          id: '2',
          name: 'Pizza Palace',
          imageUrl:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
          cuisine: 'Italian',
          rating: 4.6,
          reviewCount: 189,
          deliveryTime: 35,
          deliveryFee: 800.0,
          isOpen: true,
          tags: ['Pizza', 'Italian'],
        );
      default:
        return const Restaurant(
            id: '0',
            name: 'Unknown Restaurant',
            imageUrl: '',
            cuisine: 'Unknown',
            rating: 0,
            reviewCount: 0,
            deliveryTime: 0,
            deliveryFee: 0,
            isOpen: false,
            tags: []);
    }
  }
}
