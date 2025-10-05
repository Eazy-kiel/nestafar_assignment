// lib/presentation/blocs/cart/cart_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;

  const CartState({
    this.items = const [],
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.total = 0.0,
  });

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
    );
  }

  @override
  List<Object> get props => [items, subtotal, deliveryFee, total];
}
