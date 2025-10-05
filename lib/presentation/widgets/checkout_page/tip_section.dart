import "package:flutter/material.dart";
import "package:iconsax/iconsax.dart";
import "../../../core/constants/app_colors.dart";

class TipSection extends StatelessWidget {
  final List<Map<String, dynamic>> tipOptions;
  final int selectedIndex;
  final void Function(int) onSelect;

  const TipSection(
      {super.key,
      required this.tipOptions,
      required this.selectedIndex,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 6))
          ]),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(
              child: Text("Support your delivery partner",
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500))),
          const SizedBox(width: 6),
          Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)]),
                  shape: BoxShape.circle),
              child: const Icon(Iconsax.heart5, size: 14, color: Colors.white))
        ]),
        const SizedBox(height: 18),
        Row(
            children: tipOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final tip = entry.value;
          final isSelected = selectedIndex == index;
          return Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                      right: index < tipOptions.length - 1 ? 10 : 0),
                  child: InkWell(
                      onTap: () => onSelect(index),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(colors: [
                                      AppColors.accent,
                                      Color(0xFFFFD54F)
                                    ])
                                  : null,
                              color: isSelected ? null : AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : Colors.transparent,
                                  width: 2),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                          color:
                                              AppColors.accent.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6))
                                    ]
                                  : null),
                          child: Center(
                              child: Text(tip["label"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.secondary)))))));
        }).toList())
      ]),
    );
  }
}
