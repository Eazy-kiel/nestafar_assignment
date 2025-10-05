// lib/data/models/restaurant_model.dart
import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.cuisine,
    required super.rating,
    required super.reviewCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.isOpen,
    required super.tags,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      cuisine: json['cuisine'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'].toDouble(),
      isOpen: json['isOpen'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'cuisine': cuisine,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'isOpen': isOpen,
      'tags': tags,
    };
  }
}
