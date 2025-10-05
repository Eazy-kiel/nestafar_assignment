// lib/presentation/blocs/cart/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.menuItem.id == event.menuItem.id,
    );

    List<CartItem> updatedItems;

    if (existingItemIndex >= 0) {
      // Update existing item
      updatedItems = List.from(state.items);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
        specialInstructions:
            event.specialInstructions ?? existingItem.specialInstructions,
      );
    } else {
      // Add new item
      updatedItems = List.from(state.items)
        ..add(CartItem(
          menuItem: event.menuItem,
          quantity: event.quantity,
          specialInstructions: event.specialInstructions,
        ));
    }

    _emitUpdatedState(emit, updatedItems);
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedItems = state.items
        .where((item) => item.menuItem.id != event.menuItemId)
        .toList();

    _emitUpdatedState(emit, updatedItems);
  }

  void _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCart(event.menuItemId));
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.menuItem.id == event.menuItemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    _emitUpdatedState(emit, updatedItems);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  void _emitUpdatedState(Emitter<CartState> emit, List<CartItem> items) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = items.isNotEmpty ? 500.0 : 0.0; // Base delivery fee
    final total = subtotal + deliveryFee;

    emit(state.copyWith(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
    ));
  }
}
