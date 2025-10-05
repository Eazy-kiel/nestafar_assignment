// lib/domain/usecases/track_order.dart
import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

class TrackOrder {
  final OrderRepository repository;

  TrackOrder(this.repository);

  Future<Either<Failure, Order>> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}
