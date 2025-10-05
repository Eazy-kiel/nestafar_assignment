// lib/presentation/blocs/restaurant/restaurant_event.dart
import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class LoadRestaurants extends RestaurantEvent {}

class LoadRestaurantDetails extends RestaurantEvent {
  final String restaurantId;

  const LoadRestaurantDetails(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}
