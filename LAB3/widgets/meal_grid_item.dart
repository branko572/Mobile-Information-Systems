import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/favorites_service.dart';

class MealGridItem extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealGridItem({required this.meal, required this.onTap, Key? key}) : super(key: key);

  @override
  State<MealGridItem> createState() => _MealGridItemState();
}

class _MealGridItemState extends State<MealGridItem> {
  void _toggleFavorite() {
    setState(() {
      FavoritesService.toggleMeal(widget.meal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFav = widget.meal.isFavorite;

    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: widget.meal.imageUrl.isNotEmpty
                      ? Image.network(widget.meal.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                      const Icon(Icons.broken_image))
                      : const Icon(Icons.broken_image, size: 50),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(widget.meal.name,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
