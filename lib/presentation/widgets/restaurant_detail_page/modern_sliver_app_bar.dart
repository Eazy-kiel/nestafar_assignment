import 'package:flutter/material.dart';
import '../../../domain/entities/restaurant.dart';
import 'image_placeholder.dart';

class ModernSliverAppBar extends StatelessWidget {
  final Restaurant restaurant;

  const ModernSliverAppBar({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      elevation: 0,
      pinned: false,
      stretch: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero Image with Parallax Effect
            restaurant.imageUrl.isNotEmpty
                ? Hero(
                    tag: 'restaurant_${restaurant.id}',
                    child: Image.network(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ImagePlaceholder(size: 64),
                    ),
                  )
                : const ImagePlaceholder(size: 64),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3, 0.85, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
