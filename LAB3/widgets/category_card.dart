import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/favorites_service.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const CategoryCard({
    required this.category,
    required this.onTap,
    required this.onFavoriteToggle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    category.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(category.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(
                  category.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: category.isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
