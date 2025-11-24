import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart'; // now contains CustomSearchBar
import 'category_meals_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  late Future<List<Category>> _future;
  List<Category> _all = [];
  List<Category> _filtered = [];

  @override
  void initState() {
    super.initState();
    _future = api.fetchCategories();
    _future.then((value) {
      setState(() {
        _all = value;
        _filtered = value;
      });
    }).catchError((e) {});
  }

  void _onSearch(String q) {
    setState(() {
      if (q.trim().isEmpty) {
        _filtered = _all;
      } else {
        _filtered = _all
            .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
            .toList();
      }
    });
  }

  void _openRandom() async {
    final meal = await api.fetchRandomMeal();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            tooltip: 'Random recipe',
            onPressed: _openRandom,
          )
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Column(
            children: [
              CustomSearchBar(
                onChanged: _onSearch,
                hint: 'Пребарај категории',
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 1,
                    mainAxisExtent: 260,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, idx) {
                    final cat = _filtered[idx];
                    return CategoryCard(
                      category: cat,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryMealsScreen(category: cat.name),
                          ),
                        );
                      },
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
