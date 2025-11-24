import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import '../widgets/search_bar.dart' as custom_search; // <-- rename import
import 'meal_detail_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;

  const CategoryMealsScreen({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final ApiService api = ApiService();

  late Future<List<Meal>> _future;
  List<Meal> _all = [];
  List<Meal> _filtered = [];

  @override
  void initState() {
    super.initState();

    _future = api.fetchMealsByCategory(widget.category);

    _future.then((value) {
      setState(() {
        _all = value;
        _filtered = value;
      });
    }).catchError((e) {});
  }

  void _onSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _filtered = _all);
      return;
    }

    final results = await api.searchMeals(q);

    setState(() {
      // keep only meals that belong to this category
      _filtered = results.where((m) => _all.any((a) => a.id == m.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Јадења: ${widget.category}'),
      ),
      body: FutureBuilder<List<Meal>>(
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
              // FIXED: using custom_search.SearchBar
              custom_search.CustomSearchBar(
                onChanged: _onSearch,
                hint: 'Пребарај јадења во категоријата',
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) {
                    final meal = _filtered[i];
                    return MealGridItem(
                      meal: meal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MealDetailScreen(mealId: meal.id),
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
