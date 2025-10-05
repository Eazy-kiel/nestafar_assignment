// lib/domain/repositories/order_repository.dart
import '../entities/order.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(Order order);
  Future<Either<Failure, Order>> getOrderById(String orderId);
  Future<Either<Failure, Order>> updateOrderStatus(
      String orderId, OrderStatus status);
}
