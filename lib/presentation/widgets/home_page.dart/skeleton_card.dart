// lib/presentation/widgets/skeleton_card.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SkeletonCard extends StatelessWidget {
  final int index;
  const SkeletonCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 320,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: _ShimmerEffect(),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect> {
  double _value = -1.0;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _loop();
  }

  Future<void> _loop() async {
    while (mounted && _running) {
      for (double v = -1.0; v <= 2.0; v += 0.05) {
        setState(() => _value = v);
        await Future.delayed(const Duration(milliseconds: 16));
      }
    }
  }

  @override
  void dispose() {
    _running = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            AppColors.surface,
            AppColors.background,
            AppColors.surface,
          ],
          stops: [_value - 0.3, _value, _value + 0.3],
        ),
      ),
    );
  }
}
