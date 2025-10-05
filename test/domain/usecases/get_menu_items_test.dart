import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nestafar_assignment/core/errors/failures.dart';
import 'package:nestafar_assignment/core/utils/either.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/domain/repositories/restaurant_repository.dart';
import 'package:nestafar_assignment/domain/usecases/get_menu_items.dart';

/// Mock implementation of RestaurantRepository
class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late RestaurantRepository mockRepository;
  late GetMenuItems usecase;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    usecase = GetMenuItems(mockRepository);
  });

  const restaurantId = '1';

  const tMenuItems = [
    MenuItem(
      id: 'm1',
      name: 'Jollof Rice',
      description: 'Delicious Nigerian jollof rice',
      price: 2000,
      imageUrl: 'img',
      category: 'Main',
      isAvailable: true,
      allergens: [],
      preparationTime: 15,
    ),
  ];

  group('GetMenuItems Usecase', () {
    test('should return Right(List<MenuItem>) when repository call succeeds',
        () async {
      // arrange
      when(() => mockRepository.getMenuItems(restaurantId)).thenAnswer(
          (_) async => const Right<Failure, List<MenuItem>>(tMenuItems));

      // act
      final result = await usecase(restaurantId);

      // assert
      expect(result, const Right<Failure, List<MenuItem>>(tMenuItems));
      verify(() => mockRepository.getMenuItems(restaurantId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(ServerFailure) when repository call fails',
        () async {
      // arrange
      const failure = ServerFailure('Error loading menu');
      when(() => mockRepository.getMenuItems(restaurantId)).thenAnswer(
          (_) async => const Left<Failure, List<MenuItem>>(failure));

      // act
      final result = await usecase(restaurantId);

      // assert
      expect(result, const Left<Failure, List<MenuItem>>(failure));
      verify(() => mockRepository.getMenuItems(restaurantId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
