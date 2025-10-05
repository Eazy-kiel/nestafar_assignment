// lib/presentation/widgets/checkout_loading.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Loading overlay used while checkout is in progress.
/// Renamed to CheckoutLoadingWidget to avoid name collision with bloc state.
class CheckoutLoadingWidget extends StatelessWidget {
  final Animation<double> shimmerAnimation;
  const CheckoutLoadingWidget({Key? key, required this.shimmerAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: AppColors.background.withOpacity(0.8),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular shimmering loader
              _ShimmeringLoader(animation: shimmerAnimation),
              const SizedBox(height: 28),
              Text(
                'Placing your order...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'This may take a few seconds. Please wait.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondary.withOpacity(0.9),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmeringLoader extends StatelessWidget {
  final Animation<double> animation;
  const _ShimmeringLoader({Key? key, required this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Normalize a typical [-2,2] range to 0..1
        final v = (animation.value + 2.0) / 4.0;
        final progress = v.clamp(0.0, 1.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withOpacity(0.16),
                    AppColors.accent.withOpacity(0.04),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 92,
              height: 92,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 6,
                color: AppColors.surface,
                backgroundColor: AppColors.surface.withOpacity(0.6),
              ),
            ),
            SizedBox(
              width: 92,
              height: 92,
              child: CustomPaint(
                painter: _ArcPainter(progress: progress),
              ),
            ),
            SizedBox(
              width: 64,
              height: 64,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 36,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.06;
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;

    final backgroundPaint = Paint()
      ..color = AppColors.surface.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: 0.0,
        endAngle: 3.14 * 2,
        colors: [AppColors.accent, AppColors.warning],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // animated arc
    final sweep = 3.141592653589793 * 2 * progress;
    const start = -3.141592653589793 / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start,
        sweep, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.progress != progress;
}
