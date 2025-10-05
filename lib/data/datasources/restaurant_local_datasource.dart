// lib/data/datasources/restaurant_local_datasource.dart
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

abstract class RestaurantLocalDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantById(String id);
  Future<List<MenuItemModel>> getMenuItems(String restaurantId);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  final Map<String, dynamic> _mockData = {
    'restaurants': [
      {
        'id': '1',
        'name': 'Lagoon View Bistro',
        // Specific Unsplash photo ID with a fixed-size path (web friendly)
        'imageUrl':
            'https://images.unsplash.com/photo-1730250619893-91982f0519b0?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

        'cuisine': 'Nigerian',
        'rating': 4.8,
        'reviewCount': 324,
        'deliveryTime': 25,
        'deliveryFee': 500.0,
        'isOpen': true,
        'tags': ['Popular', 'Fast Delivery', 'Nigerian Cuisine'],
      },
      {
        'id': '2',
        'name': 'Trattoria Bella Notte',
        // Italian restaurant interior (Wikimedia, stable & high-res)
        'imageUrl':
            'https://images.unsplash.com/photo-1699183385736-5c8d99251875?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cuisine': 'Italian',
        'rating': 4.6,
        'reviewCount': 189,
        'deliveryTime': 35,
        'deliveryFee': 800.0,
        'isOpen': true,
        'tags': ['Pizza', 'Italian', 'Family Friendly'],
      },
      {
        'id': '3',
        'name': 'The Burger Mexico',
        // Contemporary burger joint interior (Wikimedia)
        'imageUrl':
            'https://images.unsplash.com/photo-1676285106276-a27e8187604c?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cuisine': 'American',
        'rating': 4.4,
        'reviewCount': 267,
        'deliveryTime': 20,
        'deliveryFee': 600.0,
        'isOpen': false,
        'tags': ['Burgers', 'Fast Food', 'American'],
      },
      {
        'id': '4',
        'name': 'Sora Sushi Bar',
        // Minimal sushi bar interior (Wikimedia)
        'imageUrl':
            'https://images.unsplash.com/photo-1639650538773-ffe1d8ad9d3f?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

        'cuisine': 'Japanese',
        'rating': 4.9,
        'reviewCount': 156,
        'deliveryTime': 40,
        'deliveryFee': 1000.0,
        'isOpen': true,
        'tags': ['Sushi', 'Japanese', 'Premium'],
      },
      {
        'id': '5',
        'name': 'Casa de Tacos',
        // Bright, casual Mexican eatery interior (Wikimedia)
        'imageUrl':
            'https://images.unsplash.com/photo-1753377773393-000264c2a010?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cuisine': 'Mexican',
        'rating': 4.3,
        'reviewCount': 203,
        'deliveryTime': 30,
        'deliveryFee': 700.0,
        'isOpen': true,
        'tags': ['Mexican', 'Spicy', 'Authentic'],
      },
    ],
    'menuItems': {
      '1': [
        {
          'id': '1_1',
          'name': 'Jollof Rice with Chicken',
          'description':
              'Perfectly seasoned jollof rice served with grilled chicken and plantain',
          'price': 2500.0,
          'imageUrl':
              'https://plus.unsplash.com/premium_photo-1694141251673-1758913ade48?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8TmlnZXJpYSUyMGpvbGxvZiUyMHJpY2UlMjBhbmQlMjBjaGlja2VufGVufDB8fDB8fHww',
          'category': 'Main Course',
          'isAvailable': true,
          'allergens': [],
          'preparationTime': 20,
        },
        {
          'id': '1_2',
          'name': 'Pepper Soup',
          'description': 'Spicy Nigerian pepper soup with assorted meat',
          'price': 1800.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1708782344137-21c48d98dfcc?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bmlnZXJpYSUyMHBlcHBlciUyMHNvdXB8ZW58MHx8MHx8fDA%3D',
          'category': 'Soups',
          'isAvailable': true,
          'allergens': ['spicy'],
          'preparationTime': 15,
        },
        {
          'id': '1_3',
          'name': 'Suya Platter',
          'description': 'Grilled spiced meat skewers with onions and tomatoes',
          'price': 3000.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1586058584816-869476c63ff7?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8TmlnZXJpYSUyMGdyaWxsZWQlMjBtZWF0fGVufDB8fDB8fHww',
          'category': 'Grills',
          'isAvailable': true,
          'allergens': ['spicy'],
          'preparationTime': 25,
        },
        {
          'id': '1_4',
          'name': 'Pounded Yam & Egusi',
          'description': 'Traditional pounded yam served with rich egusi soup',
          'price': 2200.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'category': 'Main Course',
          'isAvailable': true,
          'allergens': [],
          'preparationTime': 30,
        },
      ],
      '2': [
        {
          'id': '2_1',
          'name': 'Margherita Pizza',
          'description':
              'Classic pizza with fresh tomatoes, mozzarella, and basil',
          'price': 3500.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
          'category': 'Pizza',
          'isAvailable': true,
          'allergens': ['gluten', 'dairy'],
          'preparationTime': 25,
        },
        {
          'id': '2_2',
          'name': 'Pepperoni Pizza',
          'description': 'Pepperoni pizza with extra cheese and Italian herbs',
          'price': 4200.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
          'category': 'Pizza',
          'isAvailable': true,
          'allergens': ['gluten', 'dairy'],
          'preparationTime': 25,
        },
        {
          'id': '2_3',
          'name': 'Caesar Salad',
          'description':
              'Fresh romaine lettuce with parmesan, croutons, and caesar dressing',
          'price': 2800.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
          'category': 'Salads',
          'isAvailable': true,
          'allergens': ['dairy', 'eggs'],
          'preparationTime': 10,
        },
      ],
      '3': [
        {
          'id': '3_1',
          'name': 'Classic Beef Burger',
          'description':
              'Juicy beef patty with lettuce, tomato, onion, and special sauce',
          'price': 3200.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
          'category': 'Burgers',
          'isAvailable': true,
          'allergens': ['gluten', 'dairy'],
          'preparationTime': 15,
        },
        {
          'id': '3_2',
          'name': 'Chicken Wings',
          'description': 'Crispy chicken wings with your choice of sauce',
          'price': 2800.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=400',
          'category': 'Sides',
          'isAvailable': true,
          'allergens': [],
          'preparationTime': 20,
        },
      ],
      '4': [
        {
          'id': '4_1',
          'name': 'Salmon Sashimi',
          'description': 'Fresh salmon sashimi with wasabi and soy sauce',
          'price': 4500.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
          'category': 'Sashimi',
          'isAvailable': true,
          'allergens': ['fish'],
          'preparationTime': 10,
        },
        {
          'id': '4_2',
          'name': 'California Roll',
          'description': 'Crab, avocado, and cucumber roll with sesame seeds',
          'price': 3800.0,
          'imageUrl':
              'https://plus.unsplash.com/premium_photo-1712949140561-3d0ddacc4e0e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y2FsaWZvcm5pYSUyMHN1c2hpJTIwcm9sbHxlbnwwfHwwfHx8MA%3D%3D',
          'category': 'Rolls',
          'isAvailable': true,
          'allergens': ['shellfish'],
          'preparationTime': 15,
        },
      ],
      '5': [
        {
          'id': '5_1',
          'name': 'Beef Tacos',
          'description':
              'Three soft tacos with seasoned beef, lettuce, and cheese',
          'price': 2800.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Ground_Beef_Crispy_Tacos.jpg/1024px-Ground_Beef_Crispy_Tacos.jpg',
          'category': 'Tacos',
          'isAvailable': true,
          'allergens': ['gluten', 'dairy'],
          'preparationTime': 15,
        },
        {
          'id': '5_2',
          'name': 'Chicken Quesadilla',
          'description': 'Grilled chicken and cheese quesadilla with peppers',
          'price': 3200.0,
          'imageUrl':
              'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=400',
          'category': 'Quesadillas',
          'isAvailable': true,
          'allergens': ['gluten', 'dairy'],
          'preparationTime': 12,
        },
      ],
    },
  };

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    await Future.delayed(AppConstants.mockApiDelay);

    // Simulate occasional failures
    if (DateTime.now().millisecond % 10 == 0) {
      throw const ServerException('Failed to load restaurants');
    }

    return (_mockData['restaurants'] as List)
        .map((json) => RestaurantModel.fromJson(json))
        .toList();
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    await Future.delayed(AppConstants.mockApiDelay);

    final restaurants = _mockData['restaurants'] as List;
    final restaurantJson = restaurants.firstWhere(
      (r) => r['id'] == id,
      orElse: () => throw const ServerException('Restaurant not found'),
    );

    return RestaurantModel.fromJson(restaurantJson);
  }

  @override
  Future<List<MenuItemModel>> getMenuItems(String restaurantId) async {
    await Future.delayed(AppConstants.mockApiDelay);

    final menuItems = _mockData['menuItems'] as Map<String, dynamic>;
    final items = menuItems[restaurantId] as List?;

    if (items == null) {
      throw const ServerException('Menu items not found');
    }

    return items.map((json) => MenuItemModel.fromJson(json)).toList();
  }
}
