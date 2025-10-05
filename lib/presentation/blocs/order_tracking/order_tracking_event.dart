// lib/presentation/blocs/order_tracking/order_tracking_event.dart
import 'package:equatable/equatable.dart';

abstract class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object> get props => [];
}

class StartTracking extends OrderTrackingEvent {
  final String orderId;

  const StartTracking(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class RefreshOrderStatus extends OrderTrackingEvent {}

class StopTracking extends OrderTrackingEvent {}
