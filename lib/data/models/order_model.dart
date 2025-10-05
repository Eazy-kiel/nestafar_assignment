import '../../domain/entities/order.dart';
import 'restaurant_model.dart';
import 'cart_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.restaurant,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.total,
    required super.deliveryAddress,
    super.specialInstructions,
    required super.status,
    required super.createdAt,
    super.estimatedDeliveryTime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'],
      specialInstructions: json['specialInstructions'],
      status: OrderStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> restaurantJson;
    if (restaurant is RestaurantModel) {
      restaurantJson = (restaurant as RestaurantModel).toJson();
    } else {
      final r = restaurant;
      restaurantJson = RestaurantModel(
        id: r.id,
        name: r.name,
        imageUrl: r.imageUrl,
        cuisine: r.cuisine,
        rating: r.rating,
        reviewCount: r.reviewCount,
        deliveryTime: r.deliveryTime,
        deliveryFee: r.deliveryFee,
        isOpen: r.isOpen,
        tags: r.tags,
      ).toJson();
    }

    return {
      'id': id,
      'restaurant': restaurantJson,
      'items': items.map((item) {
        if (item is CartItemModel) return item.toJson();
        final it = item;
        return CartItemModel(
                menuItem: it.menuItem,
                quantity: it.quantity,
                specialInstructions: it.specialInstructions)
            .toJson();
      }).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'specialInstructions': specialInstructions,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
    };
  }
}
