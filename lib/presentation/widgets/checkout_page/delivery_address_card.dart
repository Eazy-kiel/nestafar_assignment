import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';

class DeliveryAddressCard extends StatelessWidget {
  final TextEditingController addressController;
  final bool saveAddress;
  final VoidCallback onToggleSave;
  final void Function(String) onAddressChanged;

  const DeliveryAddressCard({
    super.key,
    required this.addressController,
    required this.saveAddress,
    required this.onToggleSave,
    required this.onAddressChanged,
  });

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
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: "Enter your delivery address",
              hintStyle: TextStyle(
                color: AppColors.secondary.withOpacity(0.4),
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(20),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.location,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            maxLines: 3,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            validator: (v) => null,
            onChanged: onAddressChanged,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onToggleSave,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: saveAddress
                          ? const LinearGradient(
                              colors: [AppColors.accent, Color(0xFFFFD54F)])
                          : null,
                      color: saveAddress ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: saveAddress
                            ? AppColors.accent
                            : AppColors.secondary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: saveAddress
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Save this address for future orders",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
