// lib/domain/usecases/create_order.dart
import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, Order>> call(Order order) async {
    return await repository.createOrder(order);
  }
}
