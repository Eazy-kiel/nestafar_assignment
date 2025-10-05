import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/errors/failures.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/restaurant.dart';
import 'package:nestafar_assignment/domain/repositories/restaurant_repository.dart';
import 'package:nestafar_assignment/domain/usecases/get_restaurants.dart';

/// Mock class for RestaurantRepository
class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late RestaurantRepository mockRepository;
  late GetRestaurants usecase;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    usecase = GetRestaurants(mockRepository);
  });

  const tRestaurants = [
    Restaurant(
      id: '1',
      name: 'Test Restaurant',
      imageUrl: 'test_url',
      cuisine: 'Test Cuisine',
      rating: 4.5,
      reviewCount: 100,
      deliveryTime: 30,
      deliveryFee: 500.0,
      isOpen: true,
      tags: ['tag1', 'tag2'],
    ),
  ];

  group('GetRestaurants Usecase', () {
    test('should return Right(List<Restaurant>) when repository call succeeds',
        () async {
      // arrange
      when(() => mockRepository.getRestaurants()).thenAnswer(
          (_) async => const Right<Failure, List<Restaurant>>(tRestaurants));

      // act
      final result = await usecase();

      // assert
      expect(result, const Right<Failure, List<Restaurant>>(tRestaurants));
      verify(() => mockRepository.getRestaurants()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(ServerFailure) when repository call fails',
        () async {
      // arrange
      const failure = ServerFailure('Server error');
      when(() => mockRepository.getRestaurants()).thenAnswer(
          (_) async => const Left<Failure, List<Restaurant>>(failure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left<Failure, List<Restaurant>>(failure));
      verify(() => mockRepository.getRestaurants()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
