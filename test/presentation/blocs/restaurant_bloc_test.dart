import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/errors/failures.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/domain/entities/restaurant.dart';
import 'package:nestafar_assignment/domain/repositories/restaurant_repository.dart';
import 'package:nestafar_assignment/domain/usecases/get_menu_items.dart';
import 'package:nestafar_assignment/domain/usecases/get_restaurants.dart';
import 'package:nestafar_assignment/presentation/blocs/restaurant/restaurant_bloc.dart';
import 'package:nestafar_assignment/presentation/blocs/restaurant/restaurant_event.dart';
import 'package:nestafar_assignment/presentation/blocs/restaurant/restaurant_state.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

class MockGetRestaurants extends Mock implements GetRestaurants {}

class MockGetMenuItems extends Mock implements GetMenuItems {}

void main() {
  late RestaurantRepository repo;
  late GetRestaurants getRestaurants;
  late GetMenuItems getMenuItems;
  late RestaurantBloc bloc;

  setUp(() {
    repo = MockRestaurantRepository();
    getRestaurants = MockGetRestaurants();
    getMenuItems = MockGetMenuItems();
    bloc = RestaurantBloc(
        getRestaurants: getRestaurants,
        getMenuItems: getMenuItems,
        repository: repo);
  });

  tearDown(() => bloc.close());

  const restaurants = [
    Restaurant(
      id: '1',
      name: 'Mama',
      imageUrl: 'img',
      cuisine: 'NG',
      rating: 4.8,
      reviewCount: 10,
      deliveryTime: 20,
      deliveryFee: 500,
      isOpen: true,
      tags: [],
    ),
  ];

  const items = [
    MenuItem(
      id: 'm1',
      name: 'Jollof',
      description: 'desc',
      price: 2000,
      imageUrl: 'img',
      category: 'Main',
      isAvailable: true,
      allergens: [],
      preparationTime: 10,
    ),
  ];

  blocTest<RestaurantBloc, RestaurantState>(
    'LoadRestaurants -> success',
    build: () => bloc,
    act: (b) {
      when(() => getRestaurants())
          .thenAnswer((_) async => const Right(restaurants));
      b.add(LoadRestaurants());
    },
    expect: () => [
      isA<RestaurantLoading>(),
      isA<RestaurantsLoaded>(),
    ],
    verify: (_) {
      verify(() => getRestaurants()).called(1);
    },
  );

  blocTest<RestaurantBloc, RestaurantState>(
    'LoadRestaurants -> failure',
    build: () => bloc,
    act: (b) {
      when(() => getRestaurants())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      b.add(LoadRestaurants());
    },
    expect: () => [
      isA<RestaurantLoading>(),
      isA<RestaurantError>(),
    ],
  );

  blocTest<RestaurantBloc, RestaurantState>(
    'LoadRestaurantDetails -> success (repo.getRestaurantById + getMenuItems)',
    build: () => bloc,
    act: (b) {
      when(() => repo.getRestaurantById('1'))
          .thenAnswer((_) async => Right(restaurants.first));
      when(() => getMenuItems('1')).thenAnswer((_) async => const Right(items));
      b.add(const LoadRestaurantDetails('1'));
    },
    expect: () => [
      isA<RestaurantLoading>(),
      isA<RestaurantDetailsLoaded>(),
    ],
    verify: (_) {
      verify(() => repo.getRestaurantById('1')).called(1);
      verify(() => getMenuItems('1')).called(1);
    },
  );

  blocTest<RestaurantBloc, RestaurantState>(
    'LoadRestaurantDetails -> failure on repo.getRestaurantById',
    build: () => bloc,
    act: (b) {
      when(() => repo.getRestaurantById('1'))
          .thenAnswer((_) async => const Left(ServerFailure('nope')));
      b.add(const LoadRestaurantDetails('1'));
    },
    expect: () => [
      isA<RestaurantLoading>(),
      isA<RestaurantError>(),
    ],
  );
}
