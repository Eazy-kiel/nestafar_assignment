// lib/data/models/menu_item_model.dart
import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.isAvailable,
    required super.allergens,
    required super.preparationTime,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      isAvailable: json['isAvailable'],
      allergens: List<String>.from(json['allergens']),
      preparationTime: json['preparationTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'allergens': allergens,
      'preparationTime': preparationTime,
    };
  }
}
