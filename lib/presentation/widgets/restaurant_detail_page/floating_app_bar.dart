import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/restaurant.dart';
import 'glass_button.dart';

class FloatingAppBar extends StatelessWidget {
  final Restaurant restaurant;
  final bool showTitle;

  const FloatingAppBar({
    super.key,
    required this.restaurant,
    required this.showTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: showTitle
              ? AppColors.background.withOpacity(0.95)
              : Colors.transparent,
          boxShadow: showTitle
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: showTitle ? 10 : 0,
              sigmaY: showTitle ? 10 : 0,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    // Back Button
                    GlassButton(
                      icon: Iconsax.arrow_left_2,
                      onPressed: () => context.pop(),
                    ),

                    // Animated Title
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: showTitle ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    // Favorite Button
                    GlassButton(
                      icon: Iconsax.heart,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Add to favorites logic
                      },
                    ),
                    const SizedBox(width: 8),

                    // Share Button
                    GlassButton(
                      icon: Iconsax.share,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Share logic
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
