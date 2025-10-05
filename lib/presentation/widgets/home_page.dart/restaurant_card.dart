// lib/presentation/widgets/restaurant_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;
import '../../../domain/entities/restaurant.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final int index;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _starController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _starAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _starController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _starAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _starController, curve: Curves.elasticOut),
    );

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _slideController.forward();
        _scaleController.forward();
        _starController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _starController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.forward();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(bottom: 24, left: 4, right: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: _isPressed
                          ? AppColors.primary.withOpacity(0.1)
                          : _isHovered
                              ? AppColors.primary.withOpacity(0.18)
                              : AppColors.primary.withOpacity(0.08),
                      blurRadius: _isPressed
                          ? 12
                          : _isHovered
                              ? 32
                              : 20,
                      offset: _isPressed
                          ? const Offset(0, 4)
                          : _isHovered
                              ? const Offset(0, 12)
                              : const Offset(0, 6),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(context),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRestaurantHeader(context),
                            const SizedBox(height: 8),
                            _buildCuisineType(context),
                            const SizedBox(height: 16),
                            _buildMetricsRow(context),
                            if (widget.restaurant.tags.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _buildTags(context),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Hero(
      tag: 'restaurant_${widget.restaurant.name}',
      child: Stack(
        children: [
          // Main image
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 200,
            width: double.infinity,
            child: widget.restaurant.imageUrl.isNotEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.restaurant.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withOpacity(0.7),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  )
                : _buildPlaceholder(),
          ),

          // Top badges row
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRatingBadge(),
                if (!widget.restaurant.isOpen) _buildClosedBadge(),
              ],
            ),
          ),

          // Delivery info overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildDeliveryInfoOverlay(),
          ),

          // Favorite button
          Positioned(
            top: 16,
            right: 16,
            child: _buildFavoriteButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return AnimatedBuilder(
      animation: _starAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _starAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Iconsax.star5,
                  color: AppColors.accent,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.restaurant.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColors.primary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${widget.restaurant.reviewCount})',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClosedBadge() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.clock,
                  size: 16,
                  color: AppColors.background,
                ),
                SizedBox(width: 6),
                Text(
                  'Closed',
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeliveryInfoOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surface,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildInfoChip(
            icon: Iconsax.clock,
            text: '${widget.restaurant.deliveryTime} min',
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 20,
            color: AppColors.surface,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            icon: Iconsax.truck_fast,
            text: PriceFormatter.format(widget.restaurant.deliveryFee),
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                customBorder: const CircleBorder(),
                child: const Center(
                  child: Icon(
                    Iconsax.heart,
                    size: 20,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestaurantHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.restaurant.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        _buildVerifiedBadge(),
      ],
    );
  }

  Widget _buildVerifiedBadge() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * math.pi * 2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.accent.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Iconsax.verify5,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCuisineType(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Iconsax.menu_board,
                size: 14,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.restaurant.cuisine,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.08),
            AppColors.accent.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            icon: Iconsax.star5,
            value: widget.restaurant.rating.toStringAsFixed(1),
            label: 'Rating',
            color: AppColors.accent,
          ),
          _buildMetricDivider(),
          _buildMetricItem(
            icon: Iconsax.timer_1,
            value: '${widget.restaurant.deliveryTime}',
            label: 'Minutes',
            color: AppColors.primary,
          ),
          _buildMetricDivider(),
          _buildMetricItem(
            icon: Iconsax.dollar_circle,
            value: PriceFormatter.format(widget.restaurant.deliveryFee)
                .replaceAll('\$', ''),
            label: 'Delivery',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (value.length * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      width: 1,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.secondary.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.restaurant.tags.take(4).map((tag) {
        final index = widget.restaurant.tags.indexOf(tag);
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tag,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 0.2,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildPlaceholder() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.accent.withOpacity(0.1),
                AppColors.surface,
              ],
              stops: [
                _shimmerController.value - 0.3,
                _shimmerController.value,
                _shimmerController.value + 0.3,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Iconsax.gallery,
              color: AppColors.secondary.withOpacity(0.3),
              size: 48,
            ),
          ),
        );
      },
    );
  }
}
