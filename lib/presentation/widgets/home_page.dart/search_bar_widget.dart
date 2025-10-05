// lib/presentation/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: focusNode.hasFocus ? AppColors.accent : AppColors.surface,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: focusNode.hasFocus
                ? AppColors.accent.withOpacity(0.15)
                : AppColors.primary.withOpacity(0.06),
            blurRadius: focusNode.hasFocus ? 24 : 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: -0.3,
        ),
        decoration: InputDecoration(
          hintText: 'Search restaurants, cuisines...',
          hintStyle: TextStyle(
            color: AppColors.secondary.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(14),
            child: Icon(Iconsax.search_normal_1,
                color: AppColors.accent, size: 22),
          ),
          suffixIcon: hasText
              ? IconButton(
                  icon: const Icon(Iconsax.close_circle,
                      color: AppColors.secondary),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withOpacity(0.8)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Iconsax.setting_4,
                        color: AppColors.primary, size: 18),
                  ),
                ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
