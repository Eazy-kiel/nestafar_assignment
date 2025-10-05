// lib/domain/entities/menu_item.dart
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final List<String> allergens;
  final int preparationTime;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.allergens,
    required this.preparationTime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        category,
        isAvailable,
        allergens,
        preparationTime,
      ];
}
