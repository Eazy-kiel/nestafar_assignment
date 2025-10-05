// test/presentation/blocs/cart_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestafar_assignment/domain/entities/cart_item.dart';
import 'package:nestafar_assignment/domain/entities/menu_item.dart';
import 'package:nestafar_assignment/presentation/blocs/cart/cart_bloc.dart';
import 'package:nestafar_assignment/presentation/blocs/cart/cart_event.dart';
import 'package:nestafar_assignment/presentation/blocs/cart/cart_state.dart';

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = CartBloc();
  });

  tearDown(() {
    cartBloc.close();
  });

  const tMenuItem = MenuItem(
    id: '1',
    name: 'Test Item',
    description: 'Test Description',
    price: 1000.0,
    imageUrl: 'test_url',
    category: 'Test Category',
    isAvailable: true,
    allergens: [],
    preparationTime: 15,
  );

  group('CartBloc', () {
    test('initial state should be empty cart', () {
      expect(cartBloc.state, const CartState());
    });

    blocTest<CartBloc, CartState>(
      'should add item to cart when AddToCart is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(const AddToCart(tMenuItem, 1)),
      expect: () => [
        const CartState(
          items: [
            CartItem(menuItem: tMenuItem, quantity: 1),
          ],
          subtotal: 1000.0,
          deliveryFee: 500.0,
          total: 1500.0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'should update quantity when adding same item again',
      build: () => cartBloc,
      act: (bloc) {
        bloc.add(const AddToCart(tMenuItem, 1));
        bloc.add(const AddToCart(tMenuItem, 2));
      },
      expect: () => [
        const CartState(
          items: [
            CartItem(menuItem: tMenuItem, quantity: 1),
          ],
          subtotal: 1000.0,
          deliveryFee: 500.0,
          total: 1500.0,
        ),
        const CartState(
          items: [
            CartItem(menuItem: tMenuItem, quantity: 3),
          ],
          subtotal: 3000.0,
          deliveryFee: 500.0,
          total: 3500.0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'should remove item from cart when RemoveFromCart is added',
      build: () => cartBloc,
      seed: () => const CartState(
        items: [
          CartItem(menuItem: tMenuItem, quantity: 1),
        ],
        subtotal: 1000.0,
        deliveryFee: 500.0,
        total: 1500.0,
      ),
      act: (bloc) => bloc.add(const RemoveFromCart('1')),
      expect: () => [const CartState()],
    );

    blocTest<CartBloc, CartState>(
      'should clear all items when ClearCart is added',
      build: () => cartBloc,
      seed: () => const CartState(
        items: [
          CartItem(menuItem: tMenuItem, quantity: 2),
        ],
        subtotal: 2000.0,
        deliveryFee: 500.0,
        total: 2500.0,
      ),
      act: (bloc) => bloc.add(ClearCart()),
      expect: () => [const CartState()],
    );
  });
}
