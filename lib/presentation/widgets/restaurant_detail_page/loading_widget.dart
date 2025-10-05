// lib/presentation/widgets/loading_widget.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';

class LoadingWidget extends StatefulWidget {
  final String? message;
  final LoadingStyle style;

  const LoadingWidget({
    super.key,
    this.message,
    this.style = LoadingStyle.spinner,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

enum LoadingStyle {
  spinner,
  dots,
  pulse,
  gradient,
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingIndicator(),
            if (widget.message != null) ...[
              const SizedBox(height: 24),
              _AnimatedMessage(message: widget.message!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    switch (widget.style) {
      case LoadingStyle.spinner:
        return const _ModernSpinner();
      case LoadingStyle.dots:
        return const _DotsLoader();
      case LoadingStyle.pulse:
        return const _PulseLoader();
      case LoadingStyle.gradient:
        return const _GradientCircularLoader();
    }
  }
}

// Modern Spinner with gradient
class _ModernSpinner extends StatefulWidget {
  const _ModernSpinner();

  @override
  State<_ModernSpinner> createState() => _ModernSpinnerState();
}

class _ModernSpinnerState extends State<_ModernSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnimation.value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  AppColors.primary,
                  AppColors.accent,
                  AppColors.primary.withOpacity(0.1),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animated Dots Loader
class _DotsLoader extends StatefulWidget {
  const _DotsLoader();

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = math.sin(
              (_controller.value * 2 * math.pi) - (delay * 2 * math.pi),
            );
            final scale = 0.6 + (value * 0.4);
            final opacity = 0.4 + (value * 0.6);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(opacity),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3 * opacity),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// Pulse Loader
class _PulseLoader extends StatefulWidget {
  const _PulseLoader();

  @override
  State<_PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<_PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppColors.accent.withOpacity(_opacityAnimation.value),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.accent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Gradient Circular Loader
class _GradientCircularLoader extends StatefulWidget {
  const _GradientCircularLoader();

  @override
  State<_GradientCircularLoader> createState() =>
      _GradientCircularLoaderState();
}

class _GradientCircularLoaderState extends State<_GradientCircularLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotateAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.accent,
                    AppColors.primary.withOpacity(0.3),
                    AppColors.accent.withOpacity(0.3),
                    AppColors.primary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animated Message
class _AnimatedMessage extends StatefulWidget {
  final String message;

  const _AnimatedMessage({required this.message});

  @override
  State<_AnimatedMessage> createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<_AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: AppColors.secondary,
                  letterSpacing: 0.3,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
