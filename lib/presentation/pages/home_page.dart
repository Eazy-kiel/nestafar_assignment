// lib/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';

import '../blocs/restaurant/restaurant_bloc.dart';
import '../blocs/restaurant/restaurant_event.dart';

import '../widgets/home_page.dart/home_header.dart';
import '../widgets/home_page.dart/search_bar_widget.dart';
import '../widgets/home_page.dart/categories_section.dart';
import '../widgets/home_page.dart/restaurants_list.dart';
import '../widgets/home_page.dart/floating_header.dart';
import '../widgets/home_page.dart/cart_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Slim coordinator for the home screen. Heavy UI is delegated to widgets.
class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  // Controllers and animations.
  late final ScrollController _scrollController;
  late final AnimationController _headerAnimController;
  late final AnimationController _fabAnimController;
  late final AnimationController _categoryAnimController;

  late final Animation<double> _headerOpacity;
  late final Animation<double> _fabScale;
  late final Animation<Offset> _fabSlide;

  // Local UI state.
  bool _showFloatingHeader = false;
  String _selectedCategory = 'All';

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Iconsax.home},
    {'name': 'Local', 'icon': Iconsax.building_3},
    {'name': 'Continental', 'icon': Iconsax.global},
    {'name': 'Cafe', 'icon': Iconsax.coffee},
    {'name': 'Fine Dining', 'icon': Iconsax.crown},
    {'name': 'Fast Food', 'icon': Iconsax.flash_1},
    {'name': 'Street Food', 'icon': Iconsax.shop},
    {'name': 'Healthy', 'icon': Iconsax.health},
  ];

  @override
  void initState() {
    super.initState();

    // Trigger restaurant load.
    context.read<RestaurantBloc>().add(LoadRestaurants());

    _scrollController = ScrollController()..addListener(_onScroll);

    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _categoryAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimController,
        curve: Curves.easeOut,
      ),
    );

    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimController, curve: Curves.elasticOut),
    );

    _fabSlide = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _fabAnimController,
      curve: Curves.easeOutCubic,
    ));

    // Delayed entrance.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _fabAnimController.forward();
      _categoryAnimController.forward();
    });
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > 100 && !_showFloatingHeader) {
      setState(() => _showFloatingHeader = true);
      _headerAnimController.forward();
    } else if (offset <= 100 && _showFloatingHeader) {
      setState(() => _showFloatingHeader = false);
      _headerAnimController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimController.dispose();
    _fabAnimController.dispose();
    _categoryAnimController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildMainScrollView(),
          FloatingHeader(
            showFloating: _showFloatingHeader,
            headerAnim: _headerOpacity,
          ),
          CartFab(
            fabSlide: _fabSlide,
            fabScale: _fabScale,
            onOpenCart: () => context.push('/cart'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainScrollView() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        HomeHeader(
          headerAnimController: _headerAnimController,
          categoriesAnimController: _categoryAnimController,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: SearchBarWidget(
              controller: _searchController,
              focusNode: _searchFocus,
              onChanged: (v) => setState(() {}),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: CategoriesSection(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onSelect: (name) => setState(() => _selectedCategory = name),
            animController: _categoryAnimController,
          ),
        ),
        RestaurantsList(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          selectedCategory: _selectedCategory,
        ),
      ],
    );
  }
}
