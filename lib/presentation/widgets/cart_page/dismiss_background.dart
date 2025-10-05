import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class DismissBackground extends StatelessWidget {
  const DismissBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.error, borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Iconsax.trash, color: Colors.white, size: 24),
    );
  }
}
