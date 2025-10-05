import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class ImagePlaceholder extends StatelessWidget {
  final double size;

  const ImagePlaceholder({
    super.key,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Icon(
          Iconsax.gallery,
          color: AppColors.secondary.withOpacity(0.3),
          size: size,
        ),
      ),
    );
  }
}
