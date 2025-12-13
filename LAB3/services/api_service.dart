import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$base/categories.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List cats = data['categories'] ?? [];
      return cats.map<Category>((c) => Category.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$base/filter.php?c=$category'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List meals = data['meals'] ?? [];
      return meals.map<Meal>((m) => Meal.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load meals for $category');
    }
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final res = await http.get(Uri.parse('$base/lookup.php?i=$id'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = data['meals'] ?? [];
      return MealDetail.fromJson(list[0]);
    } else {
      throw Exception('Failed to fetch meal detail');
    }
  }

  Future<Meal> fetchRandomMeal() async {
    final res = await http.get(Uri.parse('$base/random.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = data['meals'] ?? [];
      return Meal.fromJson(list[0]);
    } else {
      throw Exception('Failed to fetch random meal');
    }
  }
}
