import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/constants/app_constants.dart';
import '../models/order_model.dart';
import 'package:uuid/uuid.dart';

class OrderRepositoryImpl implements OrderRepository {
  // Store domain Orders in-memory to avoid subtype copy issues.
  final Map<String, Order> _orders = {};
  final Uuid _uuid = const Uuid();

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      await Future.delayed(AppConstants.mockApiDelay);

      // Build a model only for creation; store as domain Order.
      final orderModel = OrderModel(
        id: _uuid.v4(),
        restaurant: order.restaurant,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        total: order.total,
        deliveryAddress: order.deliveryAddress,
        specialInstructions: order.specialInstructions,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        estimatedDeliveryTime: DateTime.now().add(
          Duration(minutes: order.restaurant.deliveryTime),
        ),
      );

      _orders[orderModel.id] = orderModel;

      // Simulate status progression
      _simulateOrderProgress(orderModel.id);

      return Right(orderModel);
    } catch (_) {
      return const Left(ServerFailure('Failed to create order'));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final order = _orders[orderId];
      if (order == null) {
        return const Left(ServerFailure('Order not found'));
      }

      return Right(order);
    } catch (_) {
      return const Left(ServerFailure('Failed to get order'));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final order = _orders[orderId];
      if (order == null) {
        return const Left(ServerFailure('Order not found'));
      }

      // copyWith returns a domain Order — which now matches the map’s value type
      final updatedOrder = order.copyWith(status: status);
      _orders[orderId] = updatedOrder;

      return Right(updatedOrder);
    } catch (_) {
      return const Left(ServerFailure('Failed to update order status'));
    }
  }

  void _simulateOrderProgress(String orderId) {
    Future.delayed(const Duration(seconds: 10), () {
      updateOrderStatus(orderId, OrderStatus.confirmed);
    });

    Future.delayed(const Duration(seconds: 30), () {
      updateOrderStatus(orderId, OrderStatus.preparing);
    });

    Future.delayed(const Duration(minutes: 2), () {
      updateOrderStatus(orderId, OrderStatus.outForDelivery);
    });

    Future.delayed(const Duration(minutes: 4), () {
      updateOrderStatus(orderId, OrderStatus.delivered);
    });
  }
}
