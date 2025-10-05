import "package:flutter/material.dart";
import "../../../core/constants/app_colors.dart";

class SpecialInstructionsCard extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  const SpecialInstructionsCard(
      {Key? key, required this.controller, required this.onChanged})
      : super(key: key);

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
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: 'E.g., Ring the doorbell twice, leave at door...',
            hintStyle: TextStyle(
                color: AppColors.secondary.withOpacity(0.4), fontSize: 14),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(20)),
        maxLines: 3,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary),
        onChanged: onChanged,
      ),
    );
  }
}
