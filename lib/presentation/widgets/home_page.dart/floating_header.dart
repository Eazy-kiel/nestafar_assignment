// lib/presentation/widgets/floating_header.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class FloatingHeader extends StatelessWidget {
  final bool showFloating;
  final Animation<double> headerAnim;

  const FloatingHeader({
    Key? key,
    required this.showFloating,
    required this.headerAnim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: headerAnim,
      builder: (context, child) {
        return Opacity(
          opacity: headerAnim.value,
          child: showFloating
              ? ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.9),
                        border: const Border(
                          bottom:
                              BorderSide(color: AppColors.surface, width: 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  AppConstants.appName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    letterSpacing: -0.8,
                                  ),
                                ),
                              ),
                              _buildLocationChip(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildLocationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
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
          Icon(Iconsax.location5, color: AppColors.accent, size: 18),
          SizedBox(width: 6),
          Text('NYC',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.3,
              )),
          SizedBox(width: 4),
          Icon(Iconsax.arrow_down_1, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}
