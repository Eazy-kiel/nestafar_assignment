import "package:flutter/material.dart";
import "../../../core/constants/app_colors.dart";
import "package:iconsax/iconsax.dart";

class PromoCodeWidget extends StatelessWidget {
  final TextEditingController controller;
  const PromoCodeWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withOpacity(0.08),
                AppColors.accent.withOpacity(0.02)
              ]),
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: AppColors.accent.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: AppColors.accent.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ]),
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        Expanded(
            child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Enter promo code",
                    hintStyle: TextStyle(
                        color: AppColors.secondary.withOpacity(0.4),
                        fontSize: 14),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    prefixIcon: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColors.accent.withOpacity(0.2),
                              AppColors.accent.withOpacity(0.1)
                            ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Iconsax.ticket_discount,
                            color: AppColors.accent, size: 20))),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary))),
        const SizedBox(width: 14),
        Container(
            height: 58,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accent, Color(0xFFFFD54F)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ]),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        child: Center(
                            child: Text("Apply",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 0.3))))))),
      ]),
    );
  }
}
