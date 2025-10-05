// lib/presentation/widgets/error_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';

class CustomErrorWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? title;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  @override
  State<CustomErrorWidget> createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late AnimationController _rotateController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Shake animation
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    // Fade in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutBack,
    ));

    // Rotate animation for icon
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _shakeController.forward();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Error Icon
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating gradient ring
                      AnimatedBuilder(
                        animation: _rotateAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    AppColors.error.withOpacity(0.0),
                                    AppColors.error.withOpacity(0.3),
                                    AppColors.error.withOpacity(0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Middle circle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error.withOpacity(0.1),
                        ),
                      ),
                      // Inner icon container
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.error.withOpacity(0.2),
                              AppColors.error.withOpacity(0.25),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.warning_2,
                          size: 36,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                _SlideInText(
                  delay: 300,
                  child: Text(
                    widget.title ?? 'Oops! Something went wrong',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          letterSpacing: -0.5,
                          color: AppColors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // Error Message
                _SlideInText(
                  delay: 500,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.secondary,
                            letterSpacing: 0.2,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Retry Button
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 32),
                  _SlideInText(
                    delay: 700,
                    child: _ModernRetryButton(onPressed: widget.onRetry!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideInText extends StatefulWidget {
  final Widget child;
  final int delay;

  const _SlideInText({
    required this.child,
    this.delay = 0,
  });

  @override
  State<_SlideInText> createState() => _SlideInTextState();
}

class _SlideInTextState extends State<_SlideInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

class _ModernRetryButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _ModernRetryButton({required this.onPressed});

  @override
  State<_ModernRetryButton> createState() => _ModernRetryButtonState();
}

class _ModernRetryButtonState extends State<_ModernRetryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        Future.delayed(const Duration(milliseconds: 100), widget.onPressed);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(_isPressed ? 0.2 : 0.3),
                blurRadius: _isPressed ? 12 : 20,
                offset: Offset(0, _isPressed ? 4 : 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.refresh,
                color: AppColors.background,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Try Again',
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
