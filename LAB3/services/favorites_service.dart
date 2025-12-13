import '../models/meal.dart';

class FavoritesService {
  static final List<Meal> _favoriteMeals = [];

  static List<Meal> get favoriteMeals => _favoriteMeals;

  static bool isMealFavorite(String id) {
    return _favoriteMeals.any((m) => m.id == id);
  }

  static void toggleMeal(Meal meal) {
    if (isMealFavorite(meal.id)) {
      _favoriteMeals.removeWhere((m) => m.id == meal.id);
      meal.isFavorite = false;
    } else {
      _favoriteMeals.add(meal);
      meal.isFavorite = true;
    }
  }
}
