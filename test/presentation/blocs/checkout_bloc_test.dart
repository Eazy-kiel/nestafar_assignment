import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/cart_item.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/domain/entities/order.dart';
import 'package:nestafar_assignment/domain/entities/restaurant.dart';
import 'package:nestafar_assignment/domain/repositories/order_repository.dart';
import 'package:nestafar_assignment/domain/usecases/create_order.dart';
import 'package:nestafar_assignment/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:nestafar_assignment/presentation/blocs/checkout/checkout_event.dart';
import 'package:nestafar_assignment/presentation/blocs/checkout/checkout_state.dart';

/// Mock for OrderRepository
class MockOrderRepository extends Mock implements OrderRepository {}

/// Fake for Order (used as fallback for mocktail)
class FakeOrder extends Fake implements Order {}

void main() {
  late OrderRepository repo;
  late CreateOrder createOrder;
  late CheckoutBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeOrder());
  });

  setUp(() {
    repo = MockOrderRepository();
    createOrder = CreateOrder(repo);
    bloc = CheckoutBloc(createOrder: createOrder);
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

  test('initial state is CheckoutInitial', () {
    expect(bloc.state, isA<CheckoutInitial>());
  });

  blocTest<CheckoutBloc, CheckoutState>(
    'emits updated CheckoutInitial states when address, notes, and payment method are updated',
    build: () => bloc,
    act: (b) {
      b.add(const UpdateDeliveryAddress('12 Street Lagos'));
      b.add(const UpdateSpecialInstructions('No onions'));
      b.add(const UpdatePaymentMethod('Card Payment'));
    },
    expect: () => [
      isA<CheckoutInitial>(),
      isA<CheckoutInitial>(),
      isA<CheckoutInitial>(),
    ],
    verify: (b) {
      final state = b.state as CheckoutInitial;
      expect(state.deliveryAddress, '12 Street Lagos');
      expect(state.specialInstructions, 'No onions');
      expect(state.paymentMethod, 'Card Payment');
    },
  );

  blocTest<CheckoutBloc, CheckoutState>(
    'emits [CheckoutLoading, CheckoutSuccess] when placeOrderWithData succeeds',
    build: () => bloc,
    act: (b) async {
      final created = Order(
        id: 'order-xyz',
        restaurant: restaurant,
        items: const [item],
        subtotal: 2000,
        deliveryFee: 500,
        total: 2500,
        deliveryAddress: '12 Street',
        specialInstructions: null,
        status: OrderStatus.pending,
        createdAt: DateTime(2023, 1, 1),
        estimatedDeliveryTime: DateTime(2023, 1, 1, 12, 0),
      );

      when(() => repo.createOrder(any()))
          .thenAnswer((_) async => Right(created));

      await b.placeOrderWithData(
        restaurant: restaurant,
        items: const [item],
        subtotal: 2000,
        deliveryFee: 500,
        total: 2500,
      );
    },
    expect: () => [
      isA<CheckoutLoading>(),
      isA<CheckoutSuccess>(),
    ],
    verify: (b) {
      final s = b.state as CheckoutSuccess;
      expect(s.order.id, 'order-xyz');
    },
  );
}
