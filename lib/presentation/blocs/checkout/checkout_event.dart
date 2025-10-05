import 'package:equatable/equatable.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../domain/entities/cart_item.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class UpdateDeliveryAddress extends CheckoutEvent {
  final String address;
  const UpdateDeliveryAddress(this.address);
  @override
  List<Object> get props => [address];
}

class UpdateSpecialInstructions extends CheckoutEvent {
  final String instructions;
  const UpdateSpecialInstructions(this.instructions);
  @override
  List<Object> get props => [instructions];
}

class UpdatePaymentMethod extends CheckoutEvent {
  final String paymentMethod;
  const UpdatePaymentMethod(this.paymentMethod);
  @override
  List<Object> get props => [paymentMethod];
}

/// kept for compatibility (unused payload)
class PlaceOrder extends CheckoutEvent {}

class ResetCheckout extends CheckoutEvent {}

/// We’ll dispatch this from `placeOrderWithData(...)`.
class PlaceOrderWithData extends CheckoutEvent {
  final Restaurant restaurant;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;

  const PlaceOrderWithData({
    required this.restaurant,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  List<Object?> get props => [restaurant, items, subtotal, deliveryFee, total];
}
