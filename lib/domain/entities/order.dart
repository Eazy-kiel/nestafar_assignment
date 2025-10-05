// lib/domain/entities/order.dart
import 'package:equatable/equatable.dart';
import 'cart_item.dart';
import 'restaurant.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class Order extends Equatable {
  final String id;
  final Restaurant restaurant;
  final List<CartItem> items;

  /// Base amounts
  final double subtotal;
  final double deliveryFee;

  /// Optional charges/discounts
  final double taxAmount; // <-- added
  final double discount; // <-- added

  /// Stored total (may already include tax/discount depending on your flow)
  final double total;

  final String deliveryAddress;
  final String? specialInstructions;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;

  const Order({
    required this.id,
    required this.restaurant,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    this.taxAmount = 0.0, // <-- default
    this.discount = 0.0, // <-- default
    required this.total,
    required this.deliveryAddress,
    this.specialInstructions,
    required this.status,
    required this.createdAt,
    this.estimatedDeliveryTime,
  });

  Order copyWith({
    String? id,
    Restaurant? restaurant,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? taxAmount, // <-- added
    double? discount, // <-- added
    double? total,
    String? deliveryAddress,
    String? specialInstructions,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
  }) {
    return Order(
      id: id ?? this.id,
      restaurant: restaurant ?? this.restaurant,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxAmount: taxAmount ?? this.taxAmount, // <-- added
      discount: discount ?? this.discount, // <-- added
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }

  /// If you ever need a computed total (ignoring the stored `total`)
  /// you can use this getter in the UI instead:
  double get computedTotal => subtotal + deliveryFee + taxAmount - discount;

  @override
  List<Object?> get props => [
        id,
        restaurant,
        items,
        subtotal,
        deliveryFee,
        taxAmount, // <-- added
        discount, // <-- added
        total,
        deliveryAddress,
        specialInstructions,
        status,
        createdAt,
        estimatedDeliveryTime,
      ];
}
