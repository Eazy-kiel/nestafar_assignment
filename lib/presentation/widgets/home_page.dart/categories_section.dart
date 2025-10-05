// lib/presentation/widgets/categories_section.dart
import 'package:flutter/material.dart';

import 'category_chip.dart';

class CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelect;
  final AnimationController animController;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - animController.value)),
          child: Opacity(
            opacity: animController.value,
            child: Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 80)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: CategoryChip(
                          name: cat['name'],
                          icon: cat['icon'],
                          isSelected: selectedCategory == cat['name'],
                          onTap: () => onSelect(cat['name']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
