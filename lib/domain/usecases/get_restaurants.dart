// lib/domain/usecases/get_restaurants.dart
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

class GetRestaurants {
  final RestaurantRepository repository;

  GetRestaurants(this.repository);

  Future<Either<Failure, List<Restaurant>>> call() async {
    return await repository.getRestaurants();
  }
}
