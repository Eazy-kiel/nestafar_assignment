// lib/domain/entities/restaurant.dart
import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final int deliveryTime;
  final double deliveryFee;
  final bool isOpen;
  final List<String> tags;

  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.isOpen,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        cuisine,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        isOpen,
        tags,
      ];
}
