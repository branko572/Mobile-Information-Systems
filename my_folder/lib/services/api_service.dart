import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$base/categories.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List cats = data['categories'] ?? [];
      return cats.map((c) => Category.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$base/filter.php?c=$category');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List meals = data['meals'] ?? [];
      return meals.map((m) => Meal.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load meals for $category');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse('$base/search.php?s=$query');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List? meals = data['meals'];
      if (meals == null) return [];
      return meals.map((m) => Meal.fromJson(m)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final url = Uri.parse('$base/lookup.php?i=$id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List list = data['meals'] ?? [];
      if (list.isEmpty) throw Exception('No meal found');
      return MealDetail.fromJson(list[0]);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$base/random.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List list = data['meals'] ?? [];
      return MealDetail.fromJson(list[0]);
    } else {
      throw Exception('Failed to fetch random meal');
    }
  }
}
