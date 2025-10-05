// lib/presentation/widgets/empty_state_widget.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class EmptyStateWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final Color? accentColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.accentColor,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Fade in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

    // Pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? AppColors.accent;

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
                // Animated Icon Container
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulsing circle
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    accentColor.withOpacity(0.1),
                                    accentColor.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Middle circle
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor.withOpacity(0.08),
                        ),
                      ),
                      // Inner icon container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentColor.withOpacity(0.2),
                              accentColor.withOpacity(0.15),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 40,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                _AnimatedTextSlide(
                  delay: 200,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          letterSpacing: -0.5,
                          color: AppColors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // Message
                _AnimatedTextSlide(
                  delay: 400,
                  child: Text(
                    widget.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          height: 1.6,
                          color: AppColors.secondary,
                          letterSpacing: 0.2,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Action Button
                if (widget.action != null) ...[
                  const SizedBox(height: 32),
                  _AnimatedTextSlide(
                    delay: 600,
                    child: widget.action!,
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

class _AnimatedTextSlide extends StatefulWidget {
  final Widget child;
  final int delay;

  const _AnimatedTextSlide({
    required this.child,
    this.delay = 0,
  });

  @override
  State<_AnimatedTextSlide> createState() => _AnimatedTextSlideState();
}

class _AnimatedTextSlideState extends State<_AnimatedTextSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
