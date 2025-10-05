// lib/domain/usecases/get_menu_items.dart
import '../entities/menu_item.dart';
import '../repositories/restaurant_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

class GetMenuItems {
  final RestaurantRepository repository;

  GetMenuItems(this.repository);

  Future<Either<Failure, List<MenuItem>>> call(String restaurantId) async {
    return await repository.getMenuItems(restaurantId);
  }
}
