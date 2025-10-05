// lib/presentation/widgets/home_header.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class HomeHeader extends StatelessWidget {
  final AnimationController headerAnimController;
  final AnimationController categoriesAnimController;

  const HomeHeader({
    Key? key,
    required this.headerAnimController,
    required this.categoriesAnimController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.background, AppColors.surface],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 8),
                  _buildSubtitle(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'Hungry?',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.background,
                            letterSpacing: -1.5,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.location5,
                                color: AppColors.accent, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'NYC',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Iconsax.arrow_down_1,
                                color: AppColors.primary, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: const Text(
              '🔥 Order your favorite meals now!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
                letterSpacing: -0.2,
                height: 1.4,
              ),
            ),
          ),
        );
      },
    );
  }
}
