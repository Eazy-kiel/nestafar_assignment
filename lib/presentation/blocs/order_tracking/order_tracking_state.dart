// lib/presentation/blocs/order_tracking/order_tracking_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart';

abstract class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object> get props => [];
}

class OrderTrackingInitial extends OrderTrackingState {}

class OrderTrackingLoading extends OrderTrackingState {}

class OrderTrackingLoaded extends OrderTrackingState {
  final Order order;

  const OrderTrackingLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class OrderTrackingError extends OrderTrackingState {
  final String message;

  const OrderTrackingError(this.message);

  @override
  List<Object> get props => [message];
}
