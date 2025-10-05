import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/track_order.dart';
import 'order_tracking_event.dart';
import 'order_tracking_state.dart';

class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  final TrackOrder trackOrder;
  Timer? _trackingTimer;
  String? _currentOrderId;

  OrderTrackingBloc({required this.trackOrder})
      : super(OrderTrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<RefreshOrderStatus>(_onRefreshOrderStatus);
    on<StopTracking>(_onStopTracking);
  }

  /// Start tracking a specific order
  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<OrderTrackingState> emit,
  ) async {
    _currentOrderId = event.orderId;
    emit(OrderTrackingLoading());

    await _loadOrderStatus(emit);

    // Start periodic updates
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => add(RefreshOrderStatus()),
    );
  }

  /// Refresh the status of the current order
  Future<void> _onRefreshOrderStatus(
    RefreshOrderStatus event,
    Emitter<OrderTrackingState> emit,
  ) async {
    // fallback if _currentOrderId not set (useful for seeded bloc states)
    final effectiveOrderId = _currentOrderId ??
        (state is OrderTrackingLoaded
            ? (state as OrderTrackingLoaded).order.id
            : null);

    if (effectiveOrderId == null) return;

    _currentOrderId = effectiveOrderId;
    await _loadOrderStatus(emit);
  }

  /// Stop tracking and reset the bloc
  void _onStopTracking(StopTracking event, Emitter<OrderTrackingState> emit) {
    _trackingTimer?.cancel();
    _trackingTimer = null;
    _currentOrderId = null;
    emit(OrderTrackingInitial());
  }

  /// Private helper to fetch and emit the latest order status
  Future<void> _loadOrderStatus(Emitter<OrderTrackingState> emit) async {
    if (_currentOrderId == null) return;

    final result = await trackOrder(_currentOrderId!);
    result.fold(
      (failure) => emit(OrderTrackingError(failure.message)),
      (order) {
        _currentOrderId = order.id;
        emit(OrderTrackingLoaded(order));
      },
    );
  }

  @override
  Future<void> close() {
    _trackingTimer?.cancel();
    return super.close();
  }
}
