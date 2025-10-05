// lib/presentation/widgets/menu_item_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/entities/menu_item.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/price_formatter.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;
  final int index;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    required this.onAddToCart,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Slide in animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Button animation controller
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Shimmer animation controller
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) {
        _slideController.forward();
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
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
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.forward();
  }

  void _handleAddToCart() {
    _buttonController.forward().then((_) {
      _buttonController.reverse();
      widget.onAddToCart();
    });

    // Haptic feedback simulation
    HapticFeedback();
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
                margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _isPressed
                          ? AppColors.primary.withOpacity(0.08)
                          : _isHovered
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.primary.withOpacity(0.06),
                      blurRadius: _isPressed
                          ? 8
                          : _isHovered
                              ? 24
                              : 16,
                      offset: _isPressed
                          ? const Offset(0, 2)
                          : _isHovered
                              ? const Offset(0, 8)
                              : const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Shimmer effect overlay
                      if (!widget.menuItem.isAvailable)
                        Positioned.fill(
                          child: _buildShimmerOverlay(),
                        ),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildItemHeader(context),
                                  const SizedBox(height: 8),
                                  _buildDescription(context),
                                  const SizedBox(height: 12),
                                  _buildMetaInfo(context),
                                  if (widget.menuItem.allergens.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    _buildAllergens(context),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            _buildImageAndButton(context),
                          ],
                        ),
                      ),

                      // Available indicator
                      if (!widget.menuItem.isAvailable)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: _buildUnavailableBadge(),
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

  Widget _buildItemHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.menuItem.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: AppColors.primary,
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildPopularBadge(),
      ],
    );
  }

  Widget _buildPopularBadge() {
    if (widget.menuItem.name.length % 3 == 0) {
      // Simulating popular items
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.accent.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.star5,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
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
    return const SizedBox.shrink();
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      widget.menuItem.description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: AppColors.secondary,
            height: 1.5,
            letterSpacing: 0.1,
          ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Row(
      children: [
        // Price with gradient
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.15),
                AppColors.accent.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            PriceFormatter.format(widget.menuItem.price),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: -0.5,
                ),
          ),
        ),
        const Spacer(),
        // Prep time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Iconsax.clock,
                color: AppColors.secondary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.menuItem.preparationTime} min',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
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

  Widget _buildAllergens(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: widget.menuItem.allergens.take(4).map((allergen) {
        return TweenAnimationBuilder<double>(
          duration: Duration(
            milliseconds:
                400 + (widget.menuItem.allergens.indexOf(allergen) * 50),
          ),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.danger,
                      size: 11,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      allergen,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
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

  Widget _buildImageAndButton(BuildContext context) {
    return Column(
      children: [
        // Image with animated border and shadow
        Hero(
          tag: 'menu_item_${widget.menuItem.name}',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.accent.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.1),
                  blurRadius: _isHovered ? 20 : 12,
                  offset: const Offset(0, 4),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surface,
                          AppColors.accent.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: widget.menuItem.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.menuItem.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.primary.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Add button with bounce animation
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        final scale = 1.0 - (_buttonController.value * 0.15);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 110,
            height: 44,
            decoration: BoxDecoration(
              gradient: widget.menuItem.isAvailable
                  ? LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: widget.menuItem.isAvailable ? null : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: widget.menuItem.isAvailable
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.menuItem.isAvailable ? _handleAddToCart : null,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  alignment: Alignment.center,
                  child: widget.menuItem.isAvailable
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.add_circle5,
                              size: 20,
                              color: AppColors.background,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: AppColors.background,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Unavailable',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.accent.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Iconsax.gallery,
          color: AppColors.secondary.withOpacity(0.4),
          size: 36,
        ),
      ),
    );
  }

  Widget _buildUnavailableBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.close_circle,
            size: 14,
            color: AppColors.background,
          ),
          SizedBox(width: 4),
          Text(
            'Out of Stock',
            style: TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerOverlay() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                AppColors.background.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: [
                _shimmerController.value - 0.3,
                _shimmerController.value,
                _shimmerController.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Haptic feedback helper
class HapticFeedback {
  static void lightImpact() {
    // Implementation for haptic feedback
  }
}
