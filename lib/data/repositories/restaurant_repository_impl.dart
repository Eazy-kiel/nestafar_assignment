// lib/data/repositories/restaurant_repository_impl.dart
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/either.dart';
import '../datasources/restaurant_local_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantLocalDataSource localDataSource;

  RestaurantRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurants() async {
    try {
      final restaurants = await localDataSource.getRestaurants();
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
    try {
      final restaurant = await localDataSource.getRestaurantById(id);
      return Right(restaurant);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems(
      String restaurantId) async {
    try {
      final menuItems = await localDataSource.getMenuItems(restaurantId);
      return Right(menuItems);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}
