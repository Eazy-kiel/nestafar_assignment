// lib/presentation/pages/order_tracking_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_tracking/order_tracking_bloc.dart';
import '../blocs/order_tracking/order_tracking_event.dart';
import '../blocs/order_tracking/order_tracking_state.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/order.dart';
import '../widgets/order_tracking_page/celebration_card.dart';
import '../widgets/order_tracking_page/delivery_info_card.dart';
import '../widgets/order_tracking_page/live_tracking_card.dart';
import '../widgets/order_tracking_page/modern_app_bar.dart';
import '../widgets/order_tracking_page/modern_error_view.dart';
import '../widgets/order_tracking_page/order_header.dart';
import '../widgets/order_tracking_page/order_items_card.dart';
import '../widgets/order_tracking_page/order_timeline.dart';
import '../widgets/order_tracking_page/restaurant_card.dart';
import '../widgets/order_tracking_page/shimmer_loading_card.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  late AnimationController _celebrationController;
  late Animation<double> _pulseAnimation;
  // ignore: unused_field
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<OrderTrackingBloc>().add(StartTracking(widget.orderId));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _progressController.forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _slideController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<OrderTrackingBloc>().add(StopTracking());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: false,
        appBar: ModernAppBar(orderId: widget.orderId),
        body: BlocConsumer<OrderTrackingBloc, OrderTrackingState>(
          listener: (context, state) {
            if (state is OrderTrackingLoaded &&
                state.order.status == OrderStatus.delivered) {
              _celebrationController.forward();
              HapticFeedback.heavyImpact();
            }
          },
          builder: (context, state) {
            if (state is OrderTrackingLoading) {
              return _buildShimmerLoading();
            }

            if (state is OrderTrackingError) {
              return ModernErrorView(
                message: state.message,
                orderId: widget.orderId,
              );
            }

            if (state is OrderTrackingLoaded) {
              return _buildOrderTracking(state.order);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ShimmerLoadingCard(height: 140, pulseController: _pulseController),
          const SizedBox(height: 16),
          ShimmerLoadingCard(height: 380, pulseController: _pulseController),
          const SizedBox(height: 16),
          ShimmerLoadingCard(height: 120, pulseController: _pulseController),
          const SizedBox(height: 16),
          ShimmerLoadingCard(height: 200, pulseController: _pulseController),
        ],
      ),
    );
  }

  Widget _buildOrderTracking(Order order) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        context.read<OrderTrackingBloc>().add(StartTracking(widget.orderId));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppColors.accent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderHeader(
                order: order,
                pulseController: _pulseController,
                pulseAnimation: _pulseAnimation,
              ),
              const SizedBox(height: 20),
              if (order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.cancelled)
                LiveTrackingCard(
                  order: order,
                  pulseController: _pulseController,
                  pulseAnimation: _pulseAnimation,
                ),
              if (order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.cancelled)
                const SizedBox(height: 20),
              OrderTimeline(
                order: order,
                pulseController: _pulseController,
                pulseAnimation: _pulseAnimation,
              ),
              const SizedBox(height: 20),
              RestaurantCard(order: order),
              const SizedBox(height: 20),
              OrderItemsCard(order: order),
              const SizedBox(height: 20),
              DeliveryInfoCard(order: order),
              const SizedBox(height: 20),
              if (order.status == OrderStatus.delivered)
                CelebrationCard(
                  order: order,
                  celebrationController: _celebrationController,
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
