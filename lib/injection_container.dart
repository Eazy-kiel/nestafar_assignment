// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'data/datasources/restaurant_local_datasource.dart';
import 'data/repositories/restaurant_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'domain/repositories/restaurant_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/usecases/get_restaurants.dart';
import 'domain/usecases/get_menu_items.dart';
import 'domain/usecases/create_order.dart';
import 'domain/usecases/track_order.dart';
import 'presentation/blocs/restaurant/restaurant_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/checkout/checkout_bloc.dart';
import 'presentation/blocs/order_tracking/order_tracking_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => RestaurantBloc(
        getRestaurants: sl(),
        getMenuItems: sl(),
        repository: sl(),
      ));
  sl.registerLazySingleton(() => CartBloc());
  sl.registerFactory(() => CheckoutBloc(createOrder: sl()));
  sl.registerFactory(() => OrderTrackingBloc(trackOrder: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetRestaurants(sl()));
  sl.registerLazySingleton(() => GetMenuItems(sl()));
  sl.registerLazySingleton(() => CreateOrder(sl()));
  sl.registerLazySingleton(() => TrackOrder(sl()));

  // Repositories
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());

  // Data sources
  sl.registerLazySingleton<RestaurantLocalDataSource>(
    () => RestaurantLocalDataSourceImpl(),
  );
}
