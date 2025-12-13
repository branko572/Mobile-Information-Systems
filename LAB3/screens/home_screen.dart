// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart';
import 'category_meals_screen.dart';
import 'favorites_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<Category>> _future;
  List<Category> _all = [];
  List<Category> _filtered = [];

  @override
  void initState() {
    super.initState();
    _future = api.fetchCategories();
    _future.then((value) async {
      // load category favorites in bulk for performance
      final favSnapshot = await _firestore.collection('favoriteCategories').get();
      final favIds = favSnapshot.docs.map((d) => d.id).toSet();

      for (var cat in value) {
        cat.isFavorite = favIds.contains(cat.id);
      }

      setState(() {
        _all = value;
        _filtered = value;
      });
    }).catchError((e) => debugPrint('Error loading categories: $e'));
  }

  void _onSearch(String q) {
    setState(() {
      _filtered = q.trim().isEmpty ? _all : _all.where((c) => c.name.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  Future<void> _toggleCategoryFavorite(Category cat) async {
    setState(() => cat.isFavorite = !cat.isFavorite);
    final docRef = _firestore.collection('favoriteCategories').doc(cat.id);
    if (cat.isFavorite) {
      await docRef.set(cat.toJson());
    } else {
      await docRef.delete();
    }
  }

  void _openRandom() async {
    final meal = await api.fetchRandomMeal();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(icon: const Icon(Icons.favorite), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
          IconButton(icon: const Icon(Icons.shuffle), onPressed: _openRandom),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          if (_all.isEmpty) {
            final categories = snapshot.data ?? [];
            _all = categories;
            _filtered = categories;
          }

          return Column(
            children: [
              CustomSearchBar(onChanged: _onSearch, hint: 'Пребарај категории'),
              Expanded(
                child: _filtered.isEmpty ? const Center(child: Text('Нема категории')) : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                    mainAxisExtent: 260,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, idx) {
                    final cat = _filtered[idx];
                    return CategoryCard(
                      category: cat,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryMealsScreen(category: cat.name))),
                      onFavoriteToggle: () => _toggleCategoryFavorite(cat),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
