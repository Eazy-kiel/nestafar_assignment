import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/restaurant_detail_page.dart';
import '../../presentation/widgets/cart_page/cart_page.dart';
import '../../presentation/pages/checkout_page.dart';
import '../../presentation/pages/order_tracking_page.dart';

import '../../presentation/blocs/restaurant/restaurant_bloc.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/checkout/checkout_bloc.dart';
import '../../presentation/blocs/order_tracking/order_tracking_bloc.dart';
import '../../injection_container.dart' as di;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<RestaurantBloc>()),
          // Provide a singleton CartBloc for the app
          BlocProvider.value(value: di.sl<CartBloc>()),
        ],
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/restaurant/:id',
      builder: (context, state) {
        final restaurantId = state.pathParameters['id']!;
        return MultiBlocProvider(
          providers: [
            // Fresh RestaurantBloc for details page
            BlocProvider(create: (_) => di.sl<RestaurantBloc>()),
            // IMPORTANT: reuse the same CartBloc instance
            BlocProvider.value(value: di.sl<CartBloc>()),
          ],
          child: RestaurantDetailPage(restaurantId: restaurantId),
        );
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => BlocProvider.value(
        value: di.sl<CartBloc>(),
        child: const CartPage(),
      ),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<CheckoutBloc>()),
          BlocProvider.value(value: di.sl<CartBloc>()),
        ],
        child: const CheckoutPage(),
      ),
    ),
    GoRoute(
      path: '/order-tracking/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return BlocProvider(
          create: (_) => di.sl<OrderTrackingBloc>(),
          child: OrderTrackingPage(orderId: orderId),
        );
      },
    ),
  ],
);
