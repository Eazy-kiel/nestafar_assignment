// lib/presentation/blocs/restaurant/restaurant_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../domain/entities/menu_item.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantsLoaded extends RestaurantState {
  final List<Restaurant> restaurants;

  const RestaurantsLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantDetailsLoaded extends RestaurantState {
  final Restaurant restaurant;
  final List<MenuItem> menuItems;

  const RestaurantDetailsLoaded(this.restaurant, this.menuItems);

  @override
  List<Object> get props => [restaurant, menuItems];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object> get props => [message];
}
