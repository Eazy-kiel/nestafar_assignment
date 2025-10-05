import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/cart_item.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/domain/entities/order.dart';
import 'package:nestafar_assignment/domain/entities/restaurant.dart';
import 'package:nestafar_assignment/domain/repositories/order_repository.dart';
import 'package:nestafar_assignment/domain/usecases/track_order.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late OrderRepository repo;
  late TrackOrder usecase;

  setUp(() {
    repo = MockOrderRepository();
    usecase = TrackOrder(repo);
  });

  const restaurant = Restaurant(
    id: 'r1',
    name: 'Rest',
    imageUrl: 'img',
    cuisine: 'NG',
    rating: 4.5,
    reviewCount: 12,
    deliveryTime: 20,
    deliveryFee: 500,
    isOpen: true,
    tags: [],
  );

  const item = CartItem(
    menuItem: MenuItem(
      id: 'm1',
      name: 'Item',
      description: 'Desc',
      price: 1000,
      imageUrl: 'img',
      category: 'Main',
      isAvailable: true,
      allergens: [],
      preparationTime: 10,
    ),
    quantity: 2,
  );

  final order = Order(
    id: 'order-xyz',
    restaurant: restaurant,
    items: const [item],
    subtotal: 2000,
    deliveryFee: 500,
    total: 2500,
    deliveryAddress: 'Street',
    specialInstructions: null,
    status: OrderStatus.confirmed,
    createdAt: DateTime(2023, 1, 1),
    estimatedDeliveryTime: DateTime(2023, 1, 1, 12),
  );

  test('should return Right(Order) from repository', () async {
    when(() => repo.getOrderById('order-xyz'))
        .thenAnswer((_) async => Right(order));

    final result = await usecase('order-xyz');

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r.status), OrderStatus.confirmed);
    verify(() => repo.getOrderById('order-xyz')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
