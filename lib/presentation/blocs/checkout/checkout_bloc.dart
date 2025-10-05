import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/usecases/create_order.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreateOrder createOrder;

  CheckoutBloc({required this.createOrder}) : super(const CheckoutInitial()) {
    on<UpdateDeliveryAddress>(_onUpdateDeliveryAddress);
    on<UpdateSpecialInstructions>(_onUpdateSpecialInstructions);
    on<UpdatePaymentMethod>(_onUpdatePaymentMethod);

    // Placeholder (kept) — no-op unless you want to wire it later.
    on<PlaceOrder>(_onPlaceOrder);

    on<PlaceOrderWithData>(_onPlaceOrderWithData); // NEW
    on<ResetCheckout>(_onResetCheckout);
  }

  void _onUpdateDeliveryAddress(
    UpdateDeliveryAddress event,
    Emitter<CheckoutState> emit,
  ) {
    if (state is CheckoutInitial) {
      final current = state as CheckoutInitial;
      emit(current.copyWith(deliveryAddress: event.address));
    }
  }

  void _onUpdateSpecialInstructions(
    UpdateSpecialInstructions event,
    Emitter<CheckoutState> emit,
  ) {
    if (state is CheckoutInitial) {
      final current = state as CheckoutInitial;
      emit(current.copyWith(specialInstructions: event.instructions));
    }
  }

  void _onUpdatePaymentMethod(
    UpdatePaymentMethod event,
    Emitter<CheckoutState> emit,
  ) {
    if (state is CheckoutInitial) {
      final current = state as CheckoutInitial;
      emit(current.copyWith(paymentMethod: event.paymentMethod));
    }
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    // Intentionally left empty; use PlaceOrderWithData instead.
  }

  // NEW: the only place we use `emit` for placing orders.
  Future<void> _onPlaceOrderWithData(
    PlaceOrderWithData event,
    Emitter<CheckoutState> emit,
  ) async {
    // Ensure we have the form values captured in CheckoutInitial.
    if (state is! CheckoutInitial) return;
    final checkout = state as CheckoutInitial;

    emit(CheckoutLoading());

    final order = Order(
      id: '', // repo generates
      restaurant: event.restaurant,
      items: event.items,
      subtotal: event.subtotal,
      deliveryFee: event.deliveryFee,
      total: event.total,
      deliveryAddress: checkout.deliveryAddress,
      specialInstructions: checkout.specialInstructions.isNotEmpty
          ? checkout.specialInstructions
          : null,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    final result = await createOrder(order);
    result.fold(
      (failure) => emit(CheckoutError(failure.message)),
      (createdOrder) => emit(CheckoutSuccess(createdOrder)),
    );
  }

  void _onResetCheckout(ResetCheckout event, Emitter<CheckoutState> emit) {
    emit(const CheckoutInitial());
  }

  /// Public API for UI: dispatches the event instead of calling `emit` directly.
  Future<void> placeOrderWithData({
    required Restaurant restaurant,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
  }) async {
    // Just add an event — no `emit` here.
    add(PlaceOrderWithData(
      restaurant: restaurant,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
    ));
  }
}
