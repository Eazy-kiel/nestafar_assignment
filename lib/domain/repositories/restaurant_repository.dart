// lib/domain/repositories/restaurant_repository.dart
import '../entities/restaurant.dart';
import '../entities/menu_item.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<Restaurant>>> getRestaurants();
  Future<Either<Failure, Restaurant>> getRestaurantById(String id);
  Future<Either<Failure, List<MenuItem>>> getMenuItems(String restaurantId);
}
