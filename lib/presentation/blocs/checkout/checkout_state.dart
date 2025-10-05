// lib/presentation/blocs/checkout/checkout_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {
  final String deliveryAddress;
  final String specialInstructions;
  final String paymentMethod;

  const CheckoutInitial({
    this.deliveryAddress = '',
    this.specialInstructions = '',
    this.paymentMethod = 'Cash on Delivery',
  });

  CheckoutInitial copyWith({
    String? deliveryAddress,
    String? specialInstructions,
    String? paymentMethod,
  }) {
    return CheckoutInitial(
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object> get props =>
      [deliveryAddress, specialInstructions, paymentMethod];
}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final Order order;

  const CheckoutSuccess(this.order);

  @override
  List<Object> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object> get props => [message];
}
