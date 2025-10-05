import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_restaurants.dart';
import '../../../domain/usecases/get_menu_items.dart';
import '../../../domain/repositories/restaurant_repository.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../core/errors/failures.dart';

import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurants getRestaurants;
  final GetMenuItems _getMenuItems;
  final RestaurantRepository repository;

  RestaurantBloc({
    required this.getRestaurants,
    required GetMenuItems getMenuItems,
    required this.repository,
  })  : _getMenuItems = getMenuItems,
        super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<LoadRestaurantDetails>(_onLoadRestaurantDetails);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());

    final result = await getRestaurants();
    if (emit.isDone) return;

    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (restaurants) => emit(RestaurantsLoaded(restaurants)),
    );
  }

  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetails event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());

    // 1) Get restaurant (no async-in-fold)
    final rResult = await repository.getRestaurantById(event.restaurantId);
    if (emit.isDone) return;

    Failure? failure;
    Restaurant? restaurant;
    rResult.fold(
      (f) => failure = f,
      (r) => restaurant = r,
    );

    if (failure != null) {
      emit(RestaurantError(failure!.message));
      return;
    }

    // 2) Get menu items (no async-in-fold)
    final mResult = await _getMenuItems(event.restaurantId);
    if (emit.isDone) return;

    List<MenuItem>? items;
    failure = null;
    mResult.fold(
      (f) => failure = f,
      (mi) => items = mi,
    );

    if (failure != null) {
      emit(RestaurantError(failure!.message));
      return;
    }

    emit(RestaurantDetailsLoaded(restaurant!, items!));
  }
}
