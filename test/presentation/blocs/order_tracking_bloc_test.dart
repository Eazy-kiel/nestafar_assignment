import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/cart_item.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/domain/entities/order.dart';
import 'package:nestafar_assignment/domain/entities/restaurant.dart';
import 'package:nestafar_assignment/domain/repositories/order_repository.dart';
import 'package:nestafar_assignment/domain/usecases/track_order.dart';
import 'package:nestafar_assignment/presentation/blocs/order_tracking/order_tracking_bloc.dart';
import 'package:nestafar_assignment/presentation/blocs/order_tracking/order_tracking_event.dart';
import 'package:nestafar_assignment/presentation/blocs/order_tracking/order_tracking_state.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late OrderRepository repo;
  late TrackOrder trackOrder;
  late OrderTrackingBloc bloc;

  setUp(() {
    repo = MockOrderRepository();
    trackOrder = TrackOrder(repo);
    bloc = OrderTrackingBloc(trackOrder: trackOrder);
  });

  tearDown(() => bloc.close());

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

  final pending = Order(
    id: 'order-xyz',
    restaurant: restaurant,
    items: const [item],
    subtotal: 2000,
    deliveryFee: 500,
    total: 2500,
    deliveryAddress: 'Street',
    specialInstructions: null,
    status: OrderStatus.pending,
    createdAt: DateTime(2023, 1, 1),
    estimatedDeliveryTime: DateTime(2023, 1, 1, 12),
  );

  final delivered = pending.copyWith(status: OrderStatus.delivered);

  blocTest<OrderTrackingBloc, OrderTrackingState>(
    'StartTracking -> loads pending status',
    build: () => bloc,
    act: (b) {
      when(() => repo.getOrderById('order-xyz'))
          .thenAnswer((_) async => Right(pending));
      b.add(const StartTracking('order-xyz'));
    },
    expect: () => [
      isA<OrderTrackingLoading>(),
      isA<OrderTrackingLoaded>(),
    ],
    verify: (_) => verify(() => repo.getOrderById('order-xyz')).called(1),
  );

  blocTest<OrderTrackingBloc, OrderTrackingState>(
    'RefreshOrderStatus -> loads updated status',
    build: () => bloc,
    seed: () => OrderTrackingLoaded(pending),
    act: (b) {
      when(() => repo.getOrderById('order-xyz'))
          .thenAnswer((_) async => Right(delivered));
      b.add(RefreshOrderStatus());
    },
    expect: () => [isA<OrderTrackingLoaded>()],
    verify: (_) => verify(() => repo.getOrderById('order-xyz')).called(1),
  );
}
