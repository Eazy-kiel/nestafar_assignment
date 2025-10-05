import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/errors/failures.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/cart_item.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/domain/entities/order.dart';
import 'package:nestafar_assignment/domain/entities/restaurant.dart';
import 'package:nestafar_assignment/domain/repositories/order_repository.dart';
import 'package:nestafar_assignment/domain/usecases/create_order.dart';

/// 🧩 Mock & Fake classes
class MockOrderRepository extends Mock implements OrderRepository {}

class FakeOrder extends Fake implements Order {}

void main() {
  late CreateOrder usecase;
  late MockOrderRepository mockRepo;

  /// ✅ Register fake to avoid "Bad state" errors with mocktail
  setUpAll(() {
    registerFallbackValue(FakeOrder());
  });

  setUp(() {
    mockRepo = MockOrderRepository();
    usecase = CreateOrder(mockRepo);
  });

  /// 🧱 Dummy data
  const restaurant = Restaurant(
    id: 'r1',
    name: 'Test Restaurant',
    imageUrl: 'image_url',
    cuisine: 'Nigerian',
    rating: 4.6,
    reviewCount: 20,
    deliveryTime: 30,
    deliveryFee: 500,
    isOpen: true,
    tags: [],
  );

  const cartItem = CartItem(
    menuItem: MenuItem(
      id: 'm1',
      name: 'Jollof Rice',
      description: 'Delicious jollof rice',
      price: 2000,
      imageUrl: 'image_url',
      category: 'Main',
      isAvailable: true,
      allergens: [],
      preparationTime: 10,
    ),
    quantity: 2,
  );

  final inputOrder = Order(
    id: '',
    restaurant: restaurant,
    items: const [cartItem],
    subtotal: 4000,
    deliveryFee: 500,
    total: 4500,
    deliveryAddress: '123, Lagos',
    specialInstructions: null,
    status: OrderStatus.pending,
    createdAt: DateTime(2023, 1, 1),
    estimatedDeliveryTime: null,
  );

  // ✅ SUCCESS CASE TEST
  test('should create order and return Right(Order)', () async {
    final created = inputOrder.copyWith(id: 'order-1');

    when(() => mockRepo.createOrder(any()))
        .thenAnswer((_) async => Right(created));

    final result = await usecase(inputOrder);

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r.id), 'order-1');
    verify(() => mockRepo.createOrder(any())).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  // ❌ FAILURE CASE TEST
  test('should return Left(Failure) when repository fails', () async {
    const failure = ServerFailure('Failed to create order');

    when(() => mockRepo.createOrder(any()))
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(inputOrder);

    expect(result.isLeft, true);
    expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    verify(() => mockRepo.createOrder(any())).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
