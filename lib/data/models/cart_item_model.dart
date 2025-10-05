// lib/data/models/cart_item_model.dart
import '../../domain/entities/cart_item.dart';
import 'menu_item_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.menuItem,
    required super.quantity,
    super.specialInstructions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      menuItem: MenuItemModel.fromJson(json['menuItem']),
      quantity: json['quantity'],
      specialInstructions: json['specialInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': (menuItem as MenuItemModel).toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }
}
