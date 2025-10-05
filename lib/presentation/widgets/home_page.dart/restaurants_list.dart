// lib/presentation/widgets/restaurants_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import 'skeleton_card.dart';
import '../empty_state_widget.dart';
import '../restaurant_detail_page/error_widget.dart';
import 'restaurant_card.dart';

class RestaurantsList extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String selectedCategory;

  const RestaurantsList({
    Key? key,
    this.padding,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return SliverToBoxAdapter(
            child: Column(
              children: List.generate(3, (i) => SkeletonCard(index: i)),
            ),
          );
        }

        if (state is RestaurantError) {
          return SliverToBoxAdapter(
            child: CustomErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<RestaurantBloc>().add(LoadRestaurants()),
            ),
          );
        }

        if (state is RestaurantsLoaded) {
          final filtered = selectedCategory == 'All'
              ? state.restaurants
              : state.restaurants
                  .where((r) => r.tags.contains(selectedCategory))
                  .toList();

          if (filtered.isEmpty) {
            return const SliverToBoxAdapter(
              child: EmptyStateWidget(
                icon: Iconsax.shop,
                title: 'No restaurants available',
                message:
                    'We\'re working on adding more restaurants in your area.',
              ),
            );
          }

          return SliverPadding(
            padding: padding ?? const EdgeInsets.fromLTRB(24, 8, 24, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final restaurant = filtered[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    index: index,
                    onTap: () => context.push('/restaurant/${restaurant.id}'),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
