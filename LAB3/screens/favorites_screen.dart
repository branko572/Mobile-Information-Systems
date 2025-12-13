import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final mealFavs = FavoritesService.favoriteMeals;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: mealFavs.isEmpty
          ? const Center(child: Text('No favorite recipes yet!'))
          : ListView.builder(
        itemCount: mealFavs.length,
        itemBuilder: (context, index) {
          final meal = mealFavs[index];
          return ListTile(
            leading: meal.imageUrl.isNotEmpty
                ? Image.network(meal.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                const Icon(Icons.broken_image))
                : const Icon(Icons.broken_image),
            title: Text(meal.name.isNotEmpty ? meal.name : 'Unknown'),
            trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                FavoritesService.toggleMeal(meal);
                _refresh();
              },
            ),
          );
        },
      ),
    );
  }
}
