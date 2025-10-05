import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/restaurant/restaurant_bloc.dart';
import '../blocs/restaurant/restaurant_event.dart';
import '../blocs/restaurant/restaurant_state.dart';

import '../blocs/cart/cart_bloc.dart';

import '../widgets/restaurant_detail_page/category_tabs.dart';
import '../widgets/restaurant_detail_page/floating_app_bar.dart';
import '../widgets/restaurant_detail_page/floating_cart_button.dart';
import '../widgets/restaurant_detail_page/loading_widget.dart';
import '../widgets/restaurant_detail_page/error_widget.dart';
import '../widgets/restaurant_detail_page/modern_add_to_cart_sheet.dart';
import '../widgets/restaurant_detail_page/modern_menu_item_card.dart';
import '../widgets/restaurant_detail_page/modern_sliver_app_bar.dart';
import '../widgets/restaurant_detail_page/restaurant_info_card.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;
  bool _showTitle = false;
  String _selectedCategory = '';
  final GlobalKey _cartKey = GlobalKey();
  bool _cartPulse = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabAnimationController.forward();
    context
        .read<RestaurantBloc>()
        .add(LoadRestaurantDetails(widget.restaurantId));
  }

  void _onScroll() {
    if (_scrollController.offset > 160 && !_showTitle) {
      setState(() => _showTitle = true);
      _headerAnimationController.forward();
    } else if (_scrollController.offset <= 160 && _showTitle) {
      setState(() => _showTitle = false);
      _headerAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _triggerCartPulse() {
    setState(() => _cartPulse = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _cartPulse = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const LoadingWidget(
                message: 'Loading restaurant details...');
          }

          if (state is RestaurantError) {
            return SafeArea(
              child: CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context
                      .read<RestaurantBloc>()
                      .add(LoadRestaurantDetails(widget.restaurantId));
                },
              ),
            );
          }

          if (state is RestaurantDetailsLoaded) {
            return _buildRestaurantDetails(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRestaurantDetails(RestaurantDetailsLoaded state) {
    final Restaurant restaurant = state.restaurant;
    final List<MenuItem> menuItems = state.menuItems;

    // Group menu items by category
    final Map<String, List<MenuItem>> groupedItems = <String, List<MenuItem>>{};
    for (final item in menuItems) {
      groupedItems.putIfAbsent(item.category, () => <MenuItem>[]).add(item);
    }

    if (_selectedCategory.isEmpty && groupedItems.isNotEmpty) {
      _selectedCategory = groupedItems.keys.first;
    }

    return Stack(
      children: [
        // Main Content
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            ModernSliverAppBar(restaurant: restaurant),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Restaurant Info Card
                  RestaurantInfoCard(restaurant: restaurant),
                  const SizedBox(height: 12),

                  // Category Tabs
                  if (groupedItems.length > 1)
                    CategoryTabs(
                      categories: groupedItems.keys.toList(),
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Menu Items
            ...groupedItems.entries.map((entry) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final item = entry.value[index - 1];
                      return ModernMenuItemCard(
                        item: item,
                        index: index - 1,
                        onTap: () => _showModernAddToCartSheet(item),
                      );
                    },
                    childCount: entry.value.length + 1,
                  ),
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),

        // Modern Gradient AppBar
        FloatingAppBar(
          restaurant: restaurant,
          showTitle: _showTitle,
        ),

        // Floating Cart Button (CTA)
        FloatingCartButton(
          animationController: _fabAnimationController,
          cartKey: _cartKey,
          cartPulse: _cartPulse,
        ),
      ],
    );
  }

  void _showModernAddToCartSheet(MenuItem menuItem) {
    final cartBloc = context.read<CartBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: false,
      builder: (sheetContext) => BlocProvider.value(
        value: cartBloc,
        child: ModernAddToCartSheet(
          menuItem: menuItem,
          onAdded: _triggerCartPulse,
        ),
      ),
    );
  }
}
