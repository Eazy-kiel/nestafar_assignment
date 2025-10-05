// lib/presentation/widgets/cart_item_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/price_formatter.dart';

class CartItemTile extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final int index;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.index = 0,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _deleteController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  // ignore: unused_field
  bool _isPressed = false;
  bool _isHovered = false;
  double _swipeOffset = 0;
  bool _showDeleteConfirm = false;

  @override
  void initState() {
    super.initState();

    // Slide in animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Scale animation for press effect
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulse animation for quantity changes
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));

    // Shimmer effect
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Delete animation
    _deleteController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Start entrance animation with stagger
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  void _handleIncrease() {
    HapticFeedback.lightImpact();
    _pulseController.forward(from: 0);
    widget.onIncrease();
  }

  void _handleDecrease() {
    HapticFeedback.lightImpact();
    _pulseController.forward(from: 0);
    widget.onDecrease();
  }

  void _handleRemove() {
    HapticFeedback.mediumImpact();
    setState(() => _showDeleteConfirm = true);
  }

  void _confirmDelete() async {
    HapticFeedback.heavyImpact();
    await _deleteController.forward();
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 0.0).animate(_deleteController),
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 1.0, end: 0.0).animate(_deleteController),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 16,
              ),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _isPressed = true);
                    _scaleController.forward();
                  },
                  onTapUp: (_) {
                    setState(() => _isPressed = false);
                    _scaleController.reverse();
                  },
                  onTapCancel: () {
                    setState(() => _isPressed = false);
                    _scaleController.reverse();
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _swipeOffset += details.delta.dx;
                      _swipeOffset = _swipeOffset.clamp(-100.0, 0.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_swipeOffset < -60) {
                      _handleRemove();
                    }
                    setState(() => _swipeOffset = 0);
                  },
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.translate(
                          offset: Offset(_swipeOffset, 0),
                          child: child,
                        ),
                      );
                    },
                    child: _buildCard(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(_isHovered ? 0.12 : 0.08),
            blurRadius: _isHovered ? 24 : 16,
            offset: Offset(0, _isHovered ? 8 : 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.accent.withOpacity(_isHovered ? 0.08 : 0.04),
            blurRadius: _isHovered ? 16 : 8,
            offset: Offset(0, _isHovered ? 4 : 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: _isHovered
              ? AppColors.accent.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.06),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Animated gradient background
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.background,
                      _isHovered
                          ? AppColors.accent.withOpacity(0.03)
                          : AppColors.surface.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),

            // Shimmer effect
            if (_isHovered)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(
                              -1.0 + _shimmerController.value * 2, -1.0),
                          end: Alignment(
                              1.0 + _shimmerController.value * 2, 1.0),
                          colors: [
                            Colors.transparent,
                            AppColors.accent.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMainRow(),
                  const SizedBox(height: 16),
                  _buildQuantityRow(),
                ],
              ),
            ),

            // Delete confirmation overlay
            if (_showDeleteConfirm) _buildDeleteOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        const SizedBox(width: 16),
        Expanded(child: _buildItemDetails()),
        const SizedBox(width: 8),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'cart_item_${widget.cartItem.menuItem.id}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isHovered ? 90 : 85,
        height: _isHovered ? 90 : 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: _isHovered ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              widget.cartItem.menuItem.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.cartItem.menuItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                ),
              ),

              // Quantity badge
              Positioned(
                top: 6,
                right: 6,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '×${widget.cartItem.quantity}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item name with fade in
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Text(
            widget.cartItem.menuItem.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              height: 1.3,
              letterSpacing: -0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 6),

        // Price with gradient
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.accent,
              AppColors.accent.withOpacity(0.8),
            ],
          ).createShader(bounds),
          child: Text(
            PriceFormatter.format(widget.cartItem.menuItem.price),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),

        // Special instructions
        if (widget.cartItem.specialInstructions?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Iconsax.note_1,
                  size: 14,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    widget.cartItem.specialInstructions!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDeleteButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.8),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleRemove,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.error.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Iconsax.trash,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuantityControls(),
          _buildTotalPrice(),
        ],
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildQuantityButton(
            icon: Iconsax.minus,
            onTap: _handleDecrease,
            isDecrease: true,
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.cartItem.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildQuantityButton(
            icon: Iconsax.add,
            onTap: _handleIncrease,
            isDecrease: false,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDecrease,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDecrease
                  ? AppColors.surface.withOpacity(0.8)
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isDecrease ? AppColors.primary : AppColors.background,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.accent.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Iconsax.dollar_circle,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            PriceFormatter.format(widget.cartItem.totalPrice),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteOverlay() {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.danger,
                color: AppColors.background,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Remove this item?',
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildConfirmButton(
                    label: 'Cancel',
                    isPrimary: false,
                    onTap: () => setState(() => _showDeleteConfirm = false),
                  ),
                  const SizedBox(width: 12),
                  _buildConfirmButton(
                    label: 'Remove',
                    isPrimary: true,
                    onTap: _confirmDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.background,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary ? AppColors.error : AppColors.background,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
            AppColors.surface.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Iconsax.gallery,
          color: AppColors.secondary.withOpacity(0.5),
          size: 32,
        ),
      ),
    );
  }
}
